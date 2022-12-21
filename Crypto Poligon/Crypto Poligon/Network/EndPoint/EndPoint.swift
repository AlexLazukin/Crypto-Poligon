//
//  EndPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

enum EndPoint {
    case tickers(TickersRequestObject)
    case exchanges(ExchangesRequestObject)
}

extension EndPoint {
    var version: String {
        switch self {
        case .tickers,
                .exchanges:
            return Version.v3.rawValue
        }
    }

    var path: String {
        switch self {
        case .tickers: return "reference/tickers"
        case .exchanges: return "reference/exchanges"
        }
    }

    var httpMethod: String {
        switch self {
        case .tickers,
                .exchanges:
            return HTTPMethod.GET.rawValue
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .tickers(tickersRequestObject): return tickersRequestObject.parameters()
        case let .exchanges(exchangesRequestObject): return exchangesRequestObject.parameters()
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
