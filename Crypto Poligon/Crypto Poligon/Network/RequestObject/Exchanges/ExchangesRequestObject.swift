//
//  ExchangesRequestObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

struct ExchangesRequestObject {

    // MARK: - Public (Propeties)
    let market: MarketType?

    // MARK: - Init
    init(market: MarketType? = nil) {
        self.market = market
    }

    // MARK: - Public (Interface)
    func parameters() -> [String: String] {
        var parameters: [String: String] = [:]

        parameters["asset_class"] = market?.rawValue

        return parameters
    }
}

// MARK: - Equatable
extension ExchangesRequestObject: Equatable { }
