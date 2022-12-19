//
//  TickersViewModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine

final class TickersViewModel: ObservableObject {

    // MARK: - Public (Properties)
    @Published var currentMarket: MarketType = .stocks
    @Published var tickers: [Ticker] = []
}
