//
//  NumberFormatterHub.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 17.01.2023.
//

import Foundation

final class NumberFormatterHub {

    // MARK: - Public (Properties)
    static let shared = NumberFormatterHub()

    let currencyFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    let changesFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Init
    private init() { }
}

// MARK: - NSCopying
extension NumberFormatterHub: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}
