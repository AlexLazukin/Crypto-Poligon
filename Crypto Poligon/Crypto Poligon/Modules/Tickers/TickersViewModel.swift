//
//  TickersViewModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine
import Foundation

final class TickersViewModel: ObservableObject {

    // MARK: - Public (Properties)
    @Published var isLoading: Bool = false
    @Published var currentMarket: MarketType
    @Published var searchText: String
    @Published var tickersFiltersModel: TickersFiltersModel
    @Published var tickers: [Ticker]

    @Published var tickersRequestObject: TickersRequestObject

    // MARK: - Private (Properties)
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        currentMarket = .stocks
        searchText = ""
        tickers = []
        tickersFiltersModel = TickersFiltersModel()
        tickersRequestObject = TickersRequestObject(ticker: "", market: .stocks)

        subscriptionOnChanges()
        subscriptionOnMarketChanges()
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
