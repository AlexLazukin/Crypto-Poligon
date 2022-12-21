//
//  Transitions.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import SwiftUI

extension AnyTransition {

    // MARK: - Public
    static let appear: AnyTransition = .scale(scale: 0.7).combined(with: .opacity)
}
