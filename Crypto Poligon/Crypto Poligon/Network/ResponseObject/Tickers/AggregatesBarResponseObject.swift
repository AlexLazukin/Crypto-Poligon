//
//  AggregatesBarResponseObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 10.01.2023.
//

struct AggregatesBarResponseObject: Decodable {

    // MARK: - Public (Properties)
    let ticker: String
    let queryCount: Int
    let results: [BarPoint]?
    let status: Status?
}

extension AggregatesBarResponseObject {
    static var empty: Self {
        AggregatesBarResponseObject(ticker: "", queryCount: .zero, results: [], status: nil)
    }
}

// MARK: - Status
extension AggregatesBarResponseObject {
    enum Status: String, Decodable {
        case OK
        case DELAYED
    }
}
