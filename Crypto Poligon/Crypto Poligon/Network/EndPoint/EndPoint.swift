//
//  EndPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

enum EndPoint {
    case tickers(TickersRequestObject)
}

extension EndPoint {
    var version: String {
        switch self {
        case .tickers: return Version.v3.rawValue
        }
    }

    var path: String {
        switch self {
        case .tickers: return "reference/tickers"
        }
    }

    var httpMethod: String {
        switch self {
        case .tickers: return HTTPMethod.GET.rawValue
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .tickers(tickersRequestObject): return tickersRequestObject.parameters()
        }
    }
}

// MARK: - HTTPMethod
private extension EndPoint {
    enum HTTPMethod: String {
        case GET
    }
}

// swiftlint:disable all

// MARK: - Version
private extension EndPoint {
    enum Version: String {
        case v1, v2, v3
    }
}
