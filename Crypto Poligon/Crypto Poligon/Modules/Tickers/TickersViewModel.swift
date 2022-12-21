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
    @Published var currentMarket: MarketType = .stocks
    @Published var currentDate: Date = Date()
    @Published var searchText: String = ""
    @Published var tickers: [Ticker] = []
}
