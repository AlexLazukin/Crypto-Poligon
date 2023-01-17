//
//  ActivityIndicator.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 23.12.2022.
//

import SwiftUI

struct ActivityIndicator: View {

    // MARK: - Private (Properties)
    @State private var isAnimating: Bool = false

    // MARK: - View
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .fill(Color.accent)
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(calcScale(index: index))
                        .offset(y: calcYOffset(geometry))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .rotationEffect(!isAnimating ? .degrees(.zero) : .degrees(360))
                .animation(
                    Animation
                        .timingCurve(0.5, 0.1 + Double(index) / 5, 0.2, 1, duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            isAnimating = true
        }
    }

    // MARK: - Private (Properties)
    private func calcScale(index: Int) -> CGFloat {
        (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }

    private func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 10 - geometry.size.height / 2
    }
}
