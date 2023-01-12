//
//  BarPoint.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 10.01.2023.
//

import UIKit

struct BarPoint: Decodable {

    // MARK: - Public (Properties)
    let close: Double
    let highest: Double
    let lowest: Double
    let open: Double
    let timestamp: Double
    let volume: Double

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
        close
    }

    var date: Date {
        Date(timeIntervalSince1970: timestamp / 1000)
    }
}
