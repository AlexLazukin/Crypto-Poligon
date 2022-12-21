//
//  TickersFiltersView.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import SwiftUI

struct TickersFiltersView: View {

    // MARK: - Private (Properties)
    @ObservedObject private var viewModel: TickersFiltersViewModel
    private var interactor: TickersFiltersViewInteractorInterface

    // MARK: - Init
    init(viewModel: TickersFiltersViewModel, interactor: TickersFiltersViewInteractorInterface) {
        self.viewModel = viewModel
        self.interactor = interactor
    }

    // MARK: - View
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
        }
        .toolbar {
            centerToolBar()
        }
    }

    // MARK: - Private (Interfaces)
    private func centerToolBar() -> ToolbarItem<Void, Text> {
        ToolbarItem(placement: .principal) {
            Text(Strings.Tickers.filtersTitle)
                .font(.navigationTitle)
                .foregroundColor(.text)
        }
    }
}
