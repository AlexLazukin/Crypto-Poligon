//
//  EndPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

enum EndPoint {
    case tickers(TickersRequestObject)
    case exchanges(ExchangesRequestObject)
    case aggregatesBar(AggregatesBarRequestObject)
}

extension EndPoint {
    var version: String {
        switch self {
        case .tickers,
                .exchanges:
            return Version.v3.rawValue
        case .aggregatesBar:
            return Version.v2.rawValue
        }
    }

    var path: String {
        switch self {
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
        case .tickers,
                .exchanges,
                .aggregatesBar:
            return HTTPMethod.GET.rawValue
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .tickers(tickersRequestObject): return tickersRequestObject.parameters()
        case let .exchanges(exchangesRequestObject): return exchangesRequestObject.parameters()
        case let .aggregatesBar(aggregatesBarRequestObject): return aggregatesBarRequestObject.parameters()
        }
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
        case v1, v2, v3
    }
}
