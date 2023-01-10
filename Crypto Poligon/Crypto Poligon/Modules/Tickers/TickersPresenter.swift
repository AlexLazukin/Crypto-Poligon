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
    }

    // MARK: - Private (Interface)
    private func subscribeOnTickersUpdater() {
        tickersUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.tickers, on: viewModel)
            .store(in: &subscriptions)
    }

    private func subscribeOnMarketUpdater() {
        marketUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentMarket, on: viewModel)
            .store(in: &subscriptions)
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
        loaderUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: viewModel)
            .store(in: &subscriptions)
    }

    private func subscribeOnTickersFiltersUpdater() {
        tickersFiltersUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.tickersFiltersModel, on: viewModel)
            .store(in: &subscriptions)
    }
}

// MARK: - TickersInteractorPresenterInterface
extension TickersPresenter: TickersInteractorPresenterInterface {
    func updateTickers(_ tickers: [Ticker]) {
        tickersUpdater.send(tickers)
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
