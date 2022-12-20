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
            Color.background.edgesIgnoringSafeArea(.all)

            tickersList()
        }
        .toolbar {
            centerToolBar()
        }
        .onAppear {
            interactor.reloadTickers(market: viewModel.currentMarket)
        }
    }

    // MARK: - Private (Properties)
    private func tickersList() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.tickers, id: \.ticker) { ticker in
                    HStack {
                        Text(ticker.ticker)
                            .frame(height: 38.0)
                            .font(.ordinary)
                            .foregroundColor(.text)

                        Spacer()
                    }
                    .padding(.horizontal)

                    Divider()
                        .frame(height: 1)
                        .background(Color.background)
                        .padding(.leading)
                }
            }
            .background(Color.row)
            .cornerRadius(8)
        }
        .refreshable {
            interactor.reloadTickers(market: viewModel.currentMarket)
        }
        .padding(.horizontal)
    }

    private func centerToolBar() -> ToolbarItem<Void, AnyView> {
        ToolbarItem(placement: .principal) {
            AnyView(
                Button(
                    action: {
                        interactor.changeMarket(market: viewModel.currentMarket.next())
                        interactor.reloadTickers(market: viewModel.currentMarket)
                    },
                    label: {
                        HStack(alignment: .center, spacing: 10) {
                            Text(viewModel.currentMarket.rawValue.capitalized)
                                .font(.navigationTitle)
                                .foregroundColor(.text)

                            Image(systemName: "rectangle.2.swap")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.text)
                        }
                    }
                )
            )
        }
    }
}
