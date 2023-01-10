//
//  TickersInteractor.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine
import Foundation

// MARK: - TickersViewInteractorInterface
protocol TickersViewInteractorInterface {
    func reloadTickers(_ tickersRequestObject: TickersRequestObject)
    func changeMarket(market: MarketType)
    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel)
    func currentExchangeTapped()
}

// MARK: - TickersInteractor
final class TickersInteractor {

    // MARK: - Private (Properties)
    private var presenter: TickersInteractorPresenterInterface
    private let tickersService: TickersNetworkServiceInterface
    private let tickersLoader = PassthroughSubject<TickersRequestObject, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(presenter: TickersInteractorPresenterInterface) {
        self.presenter = presenter
        tickersService = TickersNetworkService()

        subscribeOnTickersLoader()
    }

    // MARK: - Private (Properties)
    private func subscribeOnTickersLoader() {
        tickersLoader
            .removeDuplicates()
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    self?.presenter.startLoading()
                }
            )
            .debounce(for: .milliseconds(800), scheduler: DispatchQueue.main)
            .compactMap { [weak self] tickersRequestObject in
                self?.tickersService.requestTickers(tickersRequestObject)
                    .catch { [weak self] failure -> Just<[Ticker]> in
                        self?.presenter.handleFailure(failure)
                        return Just([])
                    }
            }
            .switchToLatest()
            .sink { [weak self] tickers in
                self?.presenter.updateTickers(tickers)
                self?.presenter.stopLoading()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - TickersViewInteractorInterface
extension TickersInteractor: TickersViewInteractorInterface {
    func reloadTickers(_ tickersRequestObject: TickersRequestObject) {
        tickersLoader.send(tickersRequestObject)
    }

    func changeMarket(market: MarketType) {
        presenter.changeMarket(market: market)
    }

    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel) {
        presenter.filtersTapped(market: market, tickersFiltersModel: tickersFiltersModel)
    }

    func currentExchangeTapped() {
        presenter.currentExchangeTapped()
    }
}
