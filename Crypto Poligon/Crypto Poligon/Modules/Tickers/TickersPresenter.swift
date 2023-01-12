//
//  TickersPresenter.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine
import Foundation

// MARK: - TickersInteractorPresenterInterface
protocol TickersInteractorPresenterInterface {
    func updateTickers(_ tickers: [Ticker])
    func updateAggregatesBar(for ticker: String, with barPoints: [BarPoint])
    func handleFailure(_ failure: Failure)
    func changeMarket(market: MarketType)
    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel)
    func startLoading()
    func stopLoading()
    func currentExchangeTapped()
}

// MARK: - TickersPresenter
final class TickersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersViewModel!
    private let router: TickersPresenterRouterInterface
    private let tickersUpdater = PassthroughSubject<[Ticker], Never>()
    private let marketUpdater = PassthroughSubject<MarketType, Never>()
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private let loaderUpdater = PassthroughSubject<Bool, Never>()
    private let tickersFiltersUpdater = PassthroughSubject<TickersFiltersModel, Never>()
    private let barPointsUpdater = PassthroughSubject<(String, [BarPoint]), Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TickersViewModel, router: TickersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        subscribeOnTickersUpdater()
        subscribeOnMarketUpdater()
        subscribeOnFailuresHandler()
        subscribeOnLoaderUpdater()
        subscribeOnTickersFiltersUpdater()
        subscribeOnBarPointsUpdater()
    }

    // MARK: - Private (Interface)
    private func subscribeOnTickersUpdater() {
        tickersUpdater.assign(to: \.tickers, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnMarketUpdater() {
        marketUpdater.assign(to: \.currentMarket, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnFailuresHandler() {
        failuresHandler
            .receive(on: DispatchQueue.main)
            .sink { [weak self] failure in
                self?.router.showErrorAlert(failure.description)
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnLoaderUpdater() {
        loaderUpdater.assign(to: \.isLoading, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnTickersFiltersUpdater() {
        tickersFiltersUpdater.assign(to: \.tickersFiltersModel, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnBarPointsUpdater() {
        barPointsUpdater
            .receive(on: DispatchQueue.main)
            .sink { [weak viewModel] ticker, barPoints in
                guard let viewModel = viewModel else { return }
                viewModel.tickers = viewModel.tickers.map {
                    $0.ticker == ticker ? $0.update(with: barPoints) : $0
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - TickersInteractorPresenterInterface
extension TickersPresenter: TickersInteractorPresenterInterface {
    func updateTickers(_ tickers: [Ticker]) {
        tickersUpdater.send(tickers)
    }

    func updateAggregatesBar(for ticker: String, with barPoints: [BarPoint]) {
        barPointsUpdater.send((ticker, barPoints))
    }

    func handleFailure(_ failure: Failure) {
        failuresHandler.send(failure)
    }

    func changeMarket(market: MarketType) {
        marketUpdater.send(market)
    }

    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel) {
        router.showTickersFiltersScreen(
            market: market,
            tickersFiltersModel: tickersFiltersModel
        ) { [weak self] tickersFiltersModel in
            self?.viewModel.tickersFiltersModel = tickersFiltersModel
        }
    }

    func startLoading() {
        loaderUpdater.send(true)
    }

    func stopLoading() {
        loaderUpdater.send(false)
    }

    func currentExchangeTapped() {
        var tickersFiltersModel = viewModel.tickersFiltersModel
        tickersFiltersModel.exchange = nil
        tickersFiltersUpdater.send(tickersFiltersModel)
    }
}

private extension PassthroughSubject where Failure == Never {
    func assign<Root>(
        to referenceWritableKeyPath: ReferenceWritableKeyPath<Root, Output>,
        on root: Root,
        subscriptions: inout Set<AnyCancellable>
    ) {
        self
            .receive(on: DispatchQueue.main)
            .assign(to: referenceWritableKeyPath, on: root)
            .store(in: &subscriptions)
    }
}
