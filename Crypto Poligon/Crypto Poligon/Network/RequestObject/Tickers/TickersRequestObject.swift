//
//  TickersRequestObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

struct TickersRequestObject {

    // MARK: - Public (Propeties)
    let ticker: String?
    let type: TickerType?
    let market: MarketType?
    let exchange: String?
    // let cusip: String // The list of possible cusip code can't be received due to legal reasons
    let cik: String?
    let date: String?
    let active: Bool
    let limit: Int
    let order: Order?

    // MARK: - Init
    init(
        ticker: String? = nil,
        type: TickerType? = nil,
        market: MarketType? = nil,
        exchange: String? = nil,
        cik: String? = nil,
        date: String? = nil,
        active: Bool = true,
        limit: Int = 20,
        order: Order?
    ) {
        self.ticker = ticker
        self.type = type
        self.market = market
        self.exchange = exchange
        self.cik = cik
        self.date = date
        self.active = active
        self.limit = limit
        self.order = order
    }

    // MARK: - Public (Interface)
    func parameters() -> [String: String] {
        var parameters: [String: String] = [:]

        parameters["ticker"] = ticker
        parameters["ticker"] = type?.rawValue
        parameters["market"] = market?.rawValue
        parameters["cik"] = cik
        parameters["date"] = date
        parameters["active"] = String(active)
        parameters["limit"] = String(limit)
        parameters["order"] = order?.rawValue

        return parameters
    }
}

// MARK: - Order
extension TickersRequestObject {
    enum Order: String {
        case asc, desc
    }
}
