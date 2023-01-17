//
//  Exchange.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

struct Exchange: Decodable {

    // MARK: - Public (Properties)
    let id: Int
    let acronym: String?
    let name: String
    let url: String?
    let operatingMic: String?
}

// MARK: - Equatable
extension Exchange: Equatable { }
