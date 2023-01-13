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

    var currencyCodes: [String]? = [] // ["NZD", "New Zealand Dollar"], ["OMR", "Omani Rial"]
    var barPoints: [BarPoint]? = []

    // MARK: - Public (Interface)
    func update(with barPoints: [BarPoint]) -> Self {
        Ticker(
            ticker: ticker,
            type: type,
            name: name,
            currencyName: currencyName,
            currencyCodes: currencyCodes,
            barPoints: barPoints
        )
    }

    func update(with currencyCode: [String]) -> Self {
        Ticker(
            ticker: ticker,
            type: type,
            name: name,
            currencyName: currencyName,
            currencyCodes: currencyCode,
            barPoints: barPoints
        )
    }
}

// MARK: - Equatable
extension Ticker: Equatable {
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.ticker == rhs.ticker && lhs.barPoints?.count == rhs.barPoints?.count
    }
}
