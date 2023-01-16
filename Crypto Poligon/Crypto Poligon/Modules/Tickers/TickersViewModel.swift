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
        tickersFiltersModel = TickersFiltersModel()
        tickersRequestObject = TickersRequestObject(ticker: "", market: .stocks)

        subscriptionOnChanges()
        subscriptionOnMarketChanges()
    }

    // MARK: - Public (Interface)
    func convert(position: Double, currencyName: String) -> String {
        guard position != .zero else { return "" }
        currencyFormatter.currencyCode = currenciesCodes[currencyName.lowercased()] ?? currencyName
        return currencyFormatter.string(from: NSNumber(value: position)) ?? ""
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
            .map { searchText, currentMarket, tickersFiltersModel in
                TickersRequestObject(
                    market: currentMarket,
                    exchange: tickersFiltersModel.exchange?.operatingMic,
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
                self?.tickersFiltersModel = TickersFiltersModel()
            }
            .store(in: &subscriptions)
    }
}
