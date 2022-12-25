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

    @State private var isExchangesListShown: Bool = false
    @State private var isSeeMoreExchangesActive: Bool = false

    // MARK: - Init
    init(viewModel: TickersFiltersViewModel, interactor: TickersFiltersViewInteractorInterface) {
        self.viewModel = viewModel
        self.interactor = interactor
    }

    // MARK: - View
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            scrollContent()
                .isLoading(viewModel.isLoading)

            if viewModel.isLoading {
                ActivityIndicator()
                    .frame(width: 50, height: 50)
            }
        }
        .toolbar {
            centerToolBar()
        }
        .toolbar {
            trailingToolBar()
        }
        .onAppear {
            interactor.reloadExchangeList(market: viewModel.market)
        }
        .onReceive(viewModel.$exchanges) { exchanges in
            withAnimation(.general) {
                isExchangesListShown = !exchanges.isEmpty
            }
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

    private func trailingToolBar() -> ToolbarItem<Void, AnyView> {
        ToolbarItem(placement: .navigationBarTrailing) {
            AnyView(
                Button(
                    action: {
                        interactor.saveButtonTapped(viewModel.tickersFiltersModel)
                    },
                    label: {
                        Text(Strings.Tickers.save)
                            .font(.light)
                            .foregroundColor(.accent)
                    }
                )
            )
        }
    }

    private func scrollContent() -> some View {
        ScrollView(showsIndicators: false) {
            exchangesHeader()

            VStack(spacing: .zero) {
                if isExchangesListShown {
                    ForEach(
                        isSeeMoreExchangesActive ? viewModel.exchanges : Array(viewModel.exchanges.prefix(3)),
                        id: \.name
                    ) { exchange in
                        Button(
                            action: {
                                interactor.exchangeButtonTapped(exchange)
                            },
                            label: {
                                exchangeRow(exchange)
                                    .padding(.top)
                                    .background(
                                        viewModel.tickersFiltersModel.exchange == exchange
                                        ? Color.accent
                                        : Color.row
                                    )
                            }
                        )
                        .transition(.appear)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.row)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    private func exchangesHeader() -> some View {
        HStack(alignment: .center) {
            Text(
                viewModel.exchanges.isEmpty && !viewModel.isLoading
                ? Strings.Tickers.exchangesNotFound
                : Strings.Tickers.exchanges + " " + "(\(viewModel.exchanges.count))"
            )
            .font(.navigationTitle)
            .foregroundColor(.text)
            .padding(.vertical)

            Spacer()

            if viewModel.exchanges.count > 3 {
                Button(
                    action: {
                        withAnimation(.general) {
                            isSeeMoreExchangesActive.toggle()
                        }
                    },
                    label: {
                        Text(isSeeMoreExchangesActive ? Strings.Tickers.collapseBack : Strings.Tickers.seeMore)
                            .multilineTextAlignment(.trailing)
                            .font(.light)
                            .foregroundColor(.accent)
                    }
                )
            }
        }
    }

    private func exchangeRow(_ exchange: Exchange) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(exchange.name)
                        .font(.ordinary)
                        .foregroundColor(.text)

                    if let acronym = exchange.acronym {
                        Text(acronym)
                            .font(.light)
                            .foregroundColor(.textSecondary)
                    }
                }
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .frame(minHeight: 38)
            .padding(.horizontal)

            Divider()
                .frame(height: 1)
                .background(Color.background)
        }
    }
}
