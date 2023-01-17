//
//  Font.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 20.12.2022.
//

import SwiftUI

extension Font {

    // MARK: - Public (Properties)
    static let navigationTitle: Font = .system(size: UIDevice.isPad ? 23.0 : 18.0, weight: .bold, design: .rounded)
    static let ordinary: Font = .system(size: UIDevice.isPad ? 21.0 : 17.0, weight: .medium, design: .rounded)
    static let light: Font = .system(size: UIDevice.isPad ? 19.0 : 15.0, weight: .light, design: .rounded)
}
