//
//  Transitions.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import SwiftUI

extension AnyTransition {

    // MARK: - Public
    static let appear: AnyTransition = .move(edge: .top).combined(with: .scale(scale: 0.8)).combined(with: .opacity)
}
