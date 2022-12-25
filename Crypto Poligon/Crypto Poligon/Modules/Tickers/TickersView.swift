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

    // MARK: - Init
    init(viewModel: TickersViewModel, interactor: TickersViewInteractorInterface) {
        self.viewModel = viewModel
        self.interactor = interactor
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
    }

    // MARK: - Private (Properties)
    private func scrollContent() -> some View {
        ScrollView(showsIndicators: false) {
            searchView()
                .padding(.vertical)

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
                        .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.row)
                .cornerRadius(8)
            }
            .isLoading(viewModel.isLoading)
        }
        .padding(.horizontal)
    }

    private func searchView() -> some View {
        HStack(alignment: .center, spacing: 5) {
            if isSearchGlassShown {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.placeholder)
            }

            TextField(Strings.UIElements.search, text: $viewModel.searchText)
                .font(.ordinary)
                .foregroundColor(.text)
        }
        .padding(.horizontal)
        .frame(height: 38)
        .background(Color.row)
        .cornerRadius(8)
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
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(ticker.ticker)
                        .font(.ordinary)
                        .foregroundColor(.text)

                    Text(ticker.name)
                        .font(.light)
                        .foregroundColor(.textSecondary)
                }
                .multilineTextAlignment(.leading)

                Spacer()
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
                                .frame(width: 14, height: 14)
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
                        interactor.filtersTapped(market: viewModel.currentMarket)
                    },
                    label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 16)
                            .foregroundColor(.accent)
                    }
                )
            )
        }
    }
}
