//
//  LockedLoading.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 24.12.2022.
//

import SwiftUI

extension View {
    func isLoading(_ isLoading: Bool) -> some View {
        modifier(LockedLoading(isLoading))
    }
}

// MARK: - LockedLoading
private struct LockedLoading: ViewModifier {

    // MARK: - Private (Properties)
    private let isLoading: Bool

    // MARK: - Init
    init(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    // MARK: - ViewModifier
    func body(content: Content) -> some View {
        if isLoading {
            content
                .disabled(true)
                .blur(radius: 3.0)
        } else {
            content
        }
    }
}
