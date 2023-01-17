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
    @Published var tickersModels: [TickerRowModel]
    @Published var tickersRequestObject: TickersRequestObject

    // MARK: - Private (Properties)
    private var subscriptions = Set<AnyCancellable>()
    private let dateFormatter: DateFormatter

    // MARK: - Init
    init() {
        currentMarket = .stocks // TODO: other types of markets require a special subscription to https://polygon.io
        searchText = ""
        tickersModels = []
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
