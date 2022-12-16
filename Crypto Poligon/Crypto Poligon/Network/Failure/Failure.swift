//
//  Failure.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

enum Failure: Error {
    case invalidUrl
    case decodingError(reason: String)
    case apiError(reason: String)
    case unknown

    // MARK: - Public (Properties)
    var description: String {
        switch self {
        case .invalidUrl: return Strings.NetworkError.invalidUrl
        case let .apiError(reason): return reason
        case let .decodingError(reason): return reason
        case .unknown: return Strings.NetworkError.unknown
        }
    }
}
