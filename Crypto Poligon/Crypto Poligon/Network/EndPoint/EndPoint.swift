//
//  EndPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

enum EndPoint {
    case currenciesCodes
    case tickers(TickersRequestObject)
    case exchanges(ExchangesRequestObject)
    case aggregatesBar(AggregatesBarRequestObject)
}

extension EndPoint {
    var provider: Provider {
        switch self {
        case .currenciesCodes: return .exchangeRate
        default: return .polygon
        }
    }

    var version: String {
        switch self {
        case .tickers,
                .exchanges:
            return Version.v3.rawValue
        case .aggregatesBar:
            return Version.v2.rawValue
        case .currenciesCodes:
            return Version.v6.rawValue
        }
    }

    var path: String {
        switch self {
        case .currenciesCodes: return "codes"
        case .tickers: return "reference/tickers"
        case .exchanges: return "reference/exchanges"
        case let .aggregatesBar(requestObject):
            let ticker = requestObject.ticker
            let multiplier = requestObject.multiplier
            let timespan = requestObject.timespan
            let dateFrom = requestObject.dateFrom
            let dateTo = requestObject.dateTo
            return "aggs/ticker/\(ticker)/range/\(multiplier)/\(timespan)/\(dateFrom)/\(dateTo)" // YYYY-MM-DD
        }
    }

    var httpMethod: String {
        switch self {
        case .currenciesCodes,
                .tickers,
                .exchanges,
                .aggregatesBar:
            return HTTPMethod.GET.rawValue
        }
    }

    var parameters: [String: String]? {
        switch self {
        case .currenciesCodes: return nil
        case let .tickers(tickersRequestObject): return tickersRequestObject.parameters()
        case let .exchanges(exchangesRequestObject): return exchangesRequestObject.parameters()
        case let .aggregatesBar(aggregatesBarRequestObject): return aggregatesBarRequestObject.parameters()
        }
    }
}

// MARK: - Provider
extension EndPoint {
    enum Provider {
        case polygon, exchangeRate
    }
}

// MARK: - HTTPMethod
private extension EndPoint {
    enum HTTPMethod: String {
        case GET
    }
}

// MARK: - Version
private extension EndPoint {
    enum Version: String {
        case v1, v2, v3, v6
    }
}
