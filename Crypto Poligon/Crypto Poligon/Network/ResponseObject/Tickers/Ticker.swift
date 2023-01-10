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
    var barPoints: [BarPoint]? = []

    // MARK: - Public (Interface)
    func update(with barPoints: [BarPoint]) -> Self {
        Ticker(ticker: ticker, type: type, name: name, barPoints: barPoints)
    }
}

// MARK: - Equatable
extension Ticker: Equatable {
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.ticker == rhs.ticker && lhs.barPoints?.count == rhs.barPoints?.count
    }
}
