//
//  CurrenciesCodesResponseObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 13.01.2023.
//

struct CurrenciesCodesResponseObject: Decodable {

    // MARK: - Public (Properties)
    let supportedCodes: [[String]] // ["NZD", "New Zealand Dollar"], ["OMR", "Omani Rial"]
}
