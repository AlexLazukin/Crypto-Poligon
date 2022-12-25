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
    @Published var tickers: [Ticker]

    @Published var tickersRequestObject: TickersRequestObject

    // MARK: - Private (Properties)
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        currentMarket = .stocks
        searchText = ""
        tickers = []
        tickersRequestObject = TickersRequestObject(ticker: "", market: .stocks)

        subscriptionOnChanges()
    }

    // MARK: - Private (Interfaces)
    private func subscriptionOnChanges() {
        Publishers.CombineLatest($searchText, $currentMarket)
            .map { searchText, currentMarket in
                TickersRequestObject(ticker: searchText, market: currentMarket)
            }
            .assign(to: \.tickersRequestObject, on: self)
            .store(in: &subscriptions)
    }
}
