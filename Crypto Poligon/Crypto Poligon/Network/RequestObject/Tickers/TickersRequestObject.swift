//
//  TickersRequestObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

struct TickersRequestObject {

    // MARK: - Public (Propeties)
    var ticker: String?
    var type: TickerType?
    var market: MarketType?
    var exchange: String?
    // let cusip: String // The list of possible cusip code can't be received due to legal reasons
    var cik: String?
    var date: String?
    var search: String?
    let active: Bool = true
    let limit: Int = 20
    var order: Order?
    var sort: Sort?

    // MARK: - Public (Interface)
    func parameters() -> [String: String] {
        var parameters: [String: String] = [:]

        parameters["ticker"] = ticker
        parameters["type"] = type?.rawValue
        parameters["market"] = market?.rawValue
        parameters["exchange"] = exchange
        parameters["cik"] = cik
        parameters["date"] = date
        parameters["search"] = search
        parameters["active"] = String(active)
        parameters["limit"] = String(limit)
        parameters["order"] = order?.rawValue
        parameters["sort"] = sort?.rawValue

        return parameters
    }
}

// MARK: - Equatable
extension TickersRequestObject: Equatable { }

// MARK: - Order
extension TickersRequestObject {
    enum Order: String {
        case asc, desc
    }
}

// MARK: - Sort
extension TickersRequestObject {
    enum Sort: String {
        case ticker, name, market, locale, type, cik
        case primary = "primary_exchange"
        case currencySymbol = "currency_symbol"
        case currencyName = "currency_name"
        case baseCurrencySymbol = "base_currency_symbol"
        case baseCurrencyName = "base_currency_name"
        case compositeFigi = "composite_figi"
        case shareClassFigi = "share_class_figi"
        case lastUpdatedUtc = "last_updated_utc"
        case delistedUtc = "delisted_utc"
    }
}
