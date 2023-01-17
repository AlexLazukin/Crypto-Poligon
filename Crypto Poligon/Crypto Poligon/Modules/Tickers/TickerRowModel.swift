//
//  TickerRowModel.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 17.01.2023.
//

import SwiftUI

struct TickerRowModel {

    // MARK: - Public (Properties)
    let ticker: String
    let name: String
    let currencyName: String

    var status: AggregatesBarResponseObject.Status?
    var barPoints: [BarPoint]? = []
    var position: String = ""
    var changeValue: String = ""

    var changeValueColor: Color {
        guard
            let barPoints = barPoints,
            barPoints.isEmpty == false,
            let first = barPoints.first?.value,
            let last = barPoints.last?.value,
            first != last
        else {
            return .textSecondary
        }

        return first < last ? .green : .red
    }

    var statusImageName: String? {
        guard let barPoints = barPoints, !barPoints.isEmpty else {
            return nil
        }

        switch status {
        case .DELAYED: return "clock"
        case .OK: return "checkmark"
        default: return nil
        }
    }

    var statusImageColor: Color {
        switch status {
        case .OK: return .green
        default: return .textSecondary
        }
    }
}
