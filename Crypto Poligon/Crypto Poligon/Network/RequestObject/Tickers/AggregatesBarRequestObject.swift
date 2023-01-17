//
//  AggregatesBarRequestObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 10.01.2023.
//

struct AggregatesBarRequestObject {

    // MARK: - Public (Propeties)
    let ticker: String
    let multiplier: Int
    let timespan: Timespan
    let dateFrom: String // yyyy-MM-dd
    let dateTo: String // yyyy-MM-dd
    let limit: String = "5000"

    // MARK: - Public (Interface)
    func parameters() -> [String: String] {
        var parameters: [String: String] = [:]

        parameters["limit"] = limit

        return parameters
    }
}

// MARK: - Timespan
extension AggregatesBarRequestObject {
    enum Timespan {
        case minute, hour, day, week, month, quarter, year
    }
}
