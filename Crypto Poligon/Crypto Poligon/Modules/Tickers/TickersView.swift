//
//  TickersView.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import SwiftUI

struct TickersView: View {

    // MARK: - Private (Properties)
    @ObservedObject private var viewModel: TickersViewModel
    private var interactor: TickersViewInteractorInterface

    // MARK: - Init
    init(viewModel: TickersViewModel, interactor: TickersViewInteractorInterface) {
        self.viewModel = viewModel
        self.interactor = interactor
    }

    // MARK: - View
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)

            LazyVStack(alignment: .leading, spacing: 5.0) {
                ForEach(viewModel.tickers, id: \.ticker) { ticker in
                    Text(ticker.ticker)
                }
            }
        }
        .navigationTitle(viewModel.currentMarket.rawValue.capitalized)
        .onAppear {
            interactor.onAppear(market: viewModel.currentMarket)
        }
    }
}
