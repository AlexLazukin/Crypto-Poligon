//
//  BarPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 10.01.2023.
//

import UIKit

struct BarPoint: Decodable {

    // MARK: - Public (Properties)
    let close: Decimal
    let highest: Decimal
    let lowest: Decimal
    let open: Decimal
    let timestamp: Double
    let volume: Decimal

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case close = "c"
        case highest = "h"
        case lowest = "l"
        case open = "o"
        case timestamp = "t"
        case volume = "v"
    }
}

// MARK: - ChartPoint
extension BarPoint: ChartPoint {
    var value: CGFloat {
        CGFloat(NSDecimalNumber(decimal: close).floatValue)
    }

    var date: Date {
        Date(timeIntervalSince1970: Double(timestamp) / 1000)
    }
}
