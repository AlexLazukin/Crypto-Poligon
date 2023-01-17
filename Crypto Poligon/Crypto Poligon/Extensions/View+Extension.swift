//
//  View+Extension.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 10.01.2023.
//

import SwiftUI

extension View {

    // MARK: - Public (Properties)
    var cornerRadius: CGFloat { 8 }
    var smallIndent: CGFloat { UIDevice.isPad ? 10 : 5 }
    var iconSize: CGFloat { UIDevice.isPad ? 22 : 14 }
}
