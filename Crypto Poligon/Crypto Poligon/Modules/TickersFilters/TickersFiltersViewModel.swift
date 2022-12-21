//
//  TickersFiltersViewModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import Combine

final class TickersFiltersViewModel: ObservableObject {

    // MARK: - Public (Properties)
    @Published var market: MarketType
    @Published var exchanges: [Exchange] = []
    @Published var currentExchange: Exchange?

    // MARK: - Init
    init(market: MarketType) {
        self.market = market
    }
}
