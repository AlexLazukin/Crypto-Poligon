//
//  ExchangesResponseObject.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

struct ExchangesResponseObject: Decodable {

    // MARK: - Public (Properties)
    let results: [Exchange]
}
