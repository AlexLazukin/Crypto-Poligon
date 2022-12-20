//
//  CaseIterable.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 20.12.2022.
//

extension CaseIterable where Self: Equatable {

    // MARK: - Public (Interface)
    func next() -> Self {
        let allCases = Self.allCases
        let firstIndex = allCases.firstIndex(of: self)!
        let next = allCases.index(after: firstIndex)

        return allCases[next == allCases.endIndex ? allCases.startIndex : next]
    }
}
