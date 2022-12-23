//
//  Exchange.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

struct Exchange: Decodable {

    // MARK: - Public (Properties)
    let acronym: String?
    let name: String
    let url: String?
}
