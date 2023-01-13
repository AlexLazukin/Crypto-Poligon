//
//  TickersView.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import SwiftUI
import Combine

struct TickersView: View {

    // MARK: - Private (Properties)
    @ObservedObject private var viewModel: TickersViewModel
    private var interactor: TickersViewInteractorInterface

    @State private var isSearchGlassShown = true
    @State private var isEmptyListShown = false
    @State private var isActiveFiltersShown: Bool

    // MARK: - Init
    init(viewModel: TickersViewModel, interactor: TickersViewInteractorInterface) {
        self.viewModel = viewModel
        self.interactor = interactor
        _isActiveFiltersShown = State(initialValue: viewModel.tickersFiltersModel.exchange != nil)
    }

    // MARK: - View
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            scrollContent()

            if viewModel.isLoading {
                ActivityIndicator()
                    .frame(width: 50, height: 50)
            }
        }
        .toolbar {
            centerToolBar()
        }
        .toolbar {
            rightToolBar()
        }
        .onAppear {
            interactor.reloadTickers(viewModel.tickersRequestObject)
        }
        .onReceive(viewModel.$tickersRequestObject) { tickersRequestObject in
            interactor.reloadTickers(tickersRequestObject)
        }
        .onReceive(viewModel.$searchText) { searchText in
            withAnimation(.general) {
                isSearchGlassShown = searchText.isEmpty
            }
        }
        .onReceive(viewModel.$tickers) { tickers in
            withAnimation(.general) {
                isEmptyListShown = tickers.isEmpty
            }
        }
        .onReceive(viewModel.$tickersFiltersModel) { tickersFiltersModel in
            withAnimation(.general) {
                isActiveFiltersShown = (tickersFiltersModel.exchange != nil)
            }
        }
    }

    // MARK: - Private (Properties)
    private func scrollContent() -> some View {
        ScrollView(showsIndicators: false) {
            searchView()
                .padding(.vertical)

            filtersView()

            Group {
                if isEmptyListShown && !viewModel.isLoading {
                    emptyList()
                        .transition(.appear)
                }

                VStack {
                    if !isEmptyListShown {
                        ForEach(viewModel.tickers, id: \.ticker) { ticker in
                            ticketRow(ticker)
                                .transition(.appear)
                        }
                        .padding(.top, smallIndent)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.row)
                .cornerRadius(cornerRadius)
            }
            .isLoading(viewModel.isLoading)
        }
        .padding(.horizontal)
    }

    private func searchView() -> some View {
        HStack(alignment: .center, spacing: smallIndent) {
            if isSearchGlassShown {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(.placeholder)
            }

            TextField(Strings.UIElements.search, text: $viewModel.searchText)
                .font(.ordinary)
                .foregroundColor(.text)
        }
        .padding(.horizontal)
        .frame(height: 38)
        .background(Color.row)
        .cornerRadius(cornerRadius)
    }

    @ViewBuilder
    private func filtersView() -> some View {
        if isActiveFiltersShown {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    Text(viewModel.tickersFiltersModel.exchange?.name ?? "")
                        .font(.light)
                        .foregroundColor(.text)

                    Button(
                        action: {
                            interactor.currentExchangeTapped()
                        },
                        label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: UIDevice.isPad ? 12 : 10, height: UIDevice.isPad ? 12 : 10)
                                .foregroundColor(.background)
                        }
                    )
                }
                .padding(.vertical, smallIndent)
                .padding(.horizontal, 10)
                .background(Color.accent)
                .cornerRadius(cornerRadius)
            }
            .transition(.appear)
        }
    }

    private func emptyList() -> some View {
        Text(Strings.Tickers.notFound)
            .foregroundColor(.placeholder)
            .font(.light)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
    }

    private func ticketRow(_ ticker: Ticker) -> some View {
        VStack {
            VStack(spacing: smallIndent) {
                HStack(alignment: .top) {
                    Text(ticker.ticker)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing)

                    Spacer()

                    Text(viewModel.currenciesCodes[ticker.currencyName.lowercased()] ?? ticker.currencyName)
                        .multilineTextAlignment(.trailing)
                }
                .font(.ordinary)
                .foregroundColor(.text)

                HStack(alignment: .top) {
                    Text(ticker.name)
                        .font(.light)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    WatchListChart(chartPoints: ticker.barPoints ?? [])
                        .frame(width: UIDevice.isPad ? 180 : 80, height: UIDevice.isPad ? 100 : 45)
                }
            }
            .padding(.horizontal)

            Divider()
                .frame(height: 1)
                .background(Color.background)
                .padding(.leading)
        }
    }

    private func centerToolBar() -> ToolbarItem<Void, AnyView> {
        ToolbarItem(placement: .navigationBarLeading) {
            AnyView(
                Button(
                    action: {
                        interactor.changeMarket(market: viewModel.currentMarket.next())
                    },
                    label: {
                        HStack(alignment: .center, spacing: 10) {
                            Text(viewModel.currentMarket.rawValue.capitalized)
                                .font(.navigationTitle)
                                .foregroundColor(.text)

                            Image(systemName: "rectangle.2.swap")
                                .resizable()
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(.text)
                        }
                    }
                )
            )
        }
    }

    private func rightToolBar() -> ToolbarItem<Void, AnyView> {
        ToolbarItem(placement: .navigationBarTrailing) {
            AnyView(
                Button(
                    action: {
                        interactor.filtersTapped(
                            market: viewModel.currentMarket,
                            tickersFiltersModel: viewModel.tickersFiltersModel
                        )
                    },
                    label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: iconSize)
                            .foregroundColor(.accent)
                    }
                )
            )
        }
    }
}
