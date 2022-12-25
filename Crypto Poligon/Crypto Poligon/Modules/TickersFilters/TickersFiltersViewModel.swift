//
//  TickersFiltersViewModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import Combine

final class TickersFiltersViewModel: ObservableObject {

    // MARK: - Public (Properties)
    @Published var isLoading: Bool = false
    @Published var market: MarketType
    @Published var exchanges: [Exchange] = []
    @Published var tickersFiltersModel: TickersFiltersModel

    // MARK: - Init
    init(market: MarketType, tickersFiltersModel: TickersFiltersModel) {
        self.market = market
        self.tickersFiltersModel = tickersFiltersModel
    }
}
