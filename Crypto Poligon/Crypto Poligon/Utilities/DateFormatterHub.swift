//
//  DateFormatterHub.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.01.2023.
//

import Foundation

final class DateFormatterHub {

    // MARK: - Public (Properties)
    static let shared = DateFormatterHub()

    /// YYYY-MM-DD
    let simpleFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()

    // MARK: - Init
    private init() { }
}

// MARK: - NSCopying
extension DateFormatterHub: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}
