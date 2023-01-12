//
//  WatchListChart.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 12.01.2023.
//

import SwiftUI

// MARK: - ChartPoint
protocol ChartPoint {
    var value: CGFloat { get }
    var date: Date { get }
}

// MARK: - SimpleChart
struct WatchListChart: View {

    // MARK: - Private (Properties)
    private let chartPoints: [ChartPoint]
    private let minValue: CGFloat
    private let maxValue: CGFloat

    private var chartColor: Color {
        guard chartPoints.count > 1 else {
            return .textSecondary
        }

        return (chartPoints.last?.value ?? .zero) > (chartPoints.first?.value ?? .zero) ? .green : .red
    }

    @State private var percentage: CGFloat = .zero
    @State private var isGradientShown: Bool = false

    // MARK: - Init
    init(chartPoints: [ChartPoint]) {
        self.chartPoints = chartPoints
        let values = chartPoints.map { $0.value }
        minValue = values.min() ?? .zero
        maxValue = values.max() ?? .zero
    }

    // MARK: - View
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .global)
            let difference = maxValue - minValue
            let coefficient = frame.size.height / (difference != .zero ? difference : 1)

            ZStack {
                if isGradientShown {
                    gradientPath(frame: frame, coefficient: coefficient)
                        .fill(LinearGradient(colors: [chartColor, .clear], startPoint: .top, endPoint: .bottom))
                        .transition(.opacity)
                }

                chartPath(frame: frame, coefficient: coefficient)
                    .trim(from: .zero, to: percentage)
                    .stroke(chartColor, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .round))
                    .animation(.easeOut(duration: 1), value: percentage)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1)) {
                            isGradientShown = true
                        }
                        percentage = 1
                    }
            }
        }
    }

    // MARK: - Private (Interface)
    private func chartPath(frame: CGRect, coefficient: CGFloat) -> Path {
        guard chartPoints.count > 1 else {
            return placeholderPath(frame: frame)
        }

        var path = Path()

        path.move(
            to: CGPoint(
                x: .zero,
                y: frame.size.height - ((chartPoints.first?.value ?? .zero) - minValue) * coefficient
            )
        )

        chartPoints.indices.forEach { index in
            path.addLine(
                to: CGPoint(
                    x: (frame.width / CGFloat(chartPoints.count)) * CGFloat(index + 1),
                    y: frame.size.height - (chartPoints[index].value - minValue) * coefficient
                )
            )
        }

        return path
    }

    private func placeholderPath(frame: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: .zero, y: frame.size.height / 2))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height / 2))

        return path
    }

    private func gradientPath(frame: CGRect, coefficient: CGFloat) -> Path {
        var path = chartPath(frame: frame, coefficient: coefficient)
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: .zero, y: frame.height))
        path.addLine(
            to:
                CGPoint(
                    x: .zero,
                    y: frame.size.height - ((chartPoints.first?.value ?? .zero) - minValue) * coefficient
                )
        )
        path.closeSubpath()
        return path
    }
}
