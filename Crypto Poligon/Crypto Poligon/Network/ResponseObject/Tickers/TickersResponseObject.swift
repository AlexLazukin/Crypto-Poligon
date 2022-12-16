//
//  TickersResponseObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

struct TickersResponseObject: Decodable {

    // MARK: - Public (Properties)
    let results: [Ticker]
}
