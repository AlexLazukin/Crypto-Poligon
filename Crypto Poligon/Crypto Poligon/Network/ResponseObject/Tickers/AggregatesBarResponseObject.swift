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
    let results: [BarPoint]
}
