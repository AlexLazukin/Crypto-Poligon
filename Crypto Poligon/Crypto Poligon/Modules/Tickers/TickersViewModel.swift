//
//  TickersViewModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine
import SwiftUI

final class TickersViewModel: ObservableObject {

    // MARK: - Public (Properties)
    @Published var isLoading: Bool = false
    @Published var currentMarket: MarketType
    @Published var searchText: String
    @Published var tickersFiltersModel: TickersFiltersModel
    @Published var tickers: [Ticker]
    @Published var currenciesCodes: [String: String]

    @Published var tickersRequestObject: TickersRequestObject

    // MARK: - Private (Properties)
    private var subscriptions = Set<AnyCancellable>()
    private let dateFormatter: DateFormatter

    private lazy var currencyFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    private lazy var changesFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Init
    init() {
        currentMarket = .stocks // TODO: other types of markets require a special subscription to https://polygon.io
        searchText = ""
        tickers = []
        currenciesCodes = [:]
        dateFormatter = DateFormatterHub.shared.simpleFormatter

        let dateTo = Date()
        let dateFrom = Calendar.current.date(byAdding: .day, value: -1, to: dateTo) ?? dateTo

        tickersFiltersModel = TickersFiltersModel(dateTo: dateTo)
        tickersRequestObject = TickersRequestObject(
            ticker: "",
            market: .stocks,
            dateFrom: dateFormatter.string(from: dateFrom),
            dateTo: dateFormatter.string(from: dateTo)
        )

        subscriptionOnChanges()
        subscriptionOnMarketChanges()
    }

    // MARK: - Public (Interface)
    func closedRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        let today = Date()
        let fiveYearsAgo = calendar.date(byAdding: .year, value: -5, to: today)!
        return fiveYearsAgo...today
    }

    func convert(position: Decimal, currencyName: String) -> String {
        guard position != .zero else { return "" }
        currencyFormatter.currencyCode = currenciesCodes[currencyName.lowercased()] ?? currencyName
        let value = NSNumber(value: NSDecimalNumber(decimal: position).doubleValue)
        return currencyFormatter.string(from: value) ?? ""
    }

    func changeValue(barPoints: [BarPoint]?) -> String {
        let first = barPoints?.first?.value ?? .zero
        let last = barPoints?.last?.value ?? .zero

        guard last != .zero else {
            return changesFormatter.string(from: 0) ?? ""
        }

        let change = (last - first) / last

        return changesFormatter.string(from: NSNumber(value: change)) ?? ""
    }

    func changeColor(barPoints: [BarPoint]?) -> Color {
        guard
            let barPoints = barPoints,
            barPoints.isEmpty == false,
            let first = barPoints.first?.value,
            let last = barPoints.last?.value,
            first != last
        else {
            return .textSecondary
        }

        return first < last ? .green : .red
    }

    // MARK: - Private (Interfaces)
    private func subscriptionOnChanges() {
        Publishers.CombineLatest3($searchText, $currentMarket, $tickersFiltersModel)
            .compactMap { [weak self] searchText, currentMarket, tickersFiltersModel in
                guard let self = self else { return nil }

                let dateTo = tickersFiltersModel.dateTo
                let dateFrom = Calendar.current.date(byAdding: .day, value: -1, to: dateTo) ?? dateTo

                return TickersRequestObject(
                    market: currentMarket,
                    exchange: tickersFiltersModel.exchange?.operatingMic,
                    dateFrom: self.dateFormatter.string(from: dateFrom),
                    dateTo: self.dateFormatter.string(from: dateTo),
                    search: searchText
                )
            }
            .assign(to: \.tickersRequestObject, on: self)
            .store(in: &subscriptions)
    }

    private func subscriptionOnMarketChanges() {
        $currentMarket
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tickersFiltersModel.exchange = nil
            }
            .store(in: &subscriptions)
    }
}
