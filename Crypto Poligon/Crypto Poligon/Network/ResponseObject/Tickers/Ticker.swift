//
//  Ticker.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

struct Ticker: Decodable {

    // MARK: - Public (Properties)
    let ticker: String
    let type: TickerType?
    let name: String
    let currencyName: String
}
