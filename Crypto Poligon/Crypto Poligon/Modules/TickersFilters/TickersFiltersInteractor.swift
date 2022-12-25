//
//  TickersFiltersInteractor.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import Combine

// MARK: - TickersFiltersViewInteractorInterface
protocol TickersFiltersViewInteractorInterface {
    func reloadExchangeList(market: MarketType)
    func exchangeButtonTapped(_ exchange: Exchange)
}

// MARK: - TickersFiltersInteractor
final class TickersFiltersInteractor {

    // MARK: - Private (Properties)
    private var presenter: TickersFiltersInteractorPresenterInterface
    private let tickersService: TickersNetworkServiceInterface
    private let exchangeListLoader = PassthroughSubject<ExchangesRequestObject, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(presenter: TickersFiltersInteractorPresenterInterface) {
        self.presenter = presenter
        tickersService = TickersNetworkService()

        subscribeOnExchangeListLoader()
    }

    // MARK: - Private (Properties)
    private func subscribeOnExchangeListLoader() {
        exchangeListLoader
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    self?.presenter.startLoading()
                }
            )
            .compactMap { [weak self] exchangesRequestObject in
                self?.tickersService.requestExchanges(exchangesRequestObject)
                    .catch { [weak self] failure -> Just<[Exchange]> in
                        self?.presenter.handleFailure(failure)
                        return Just([])
                    }
            }
            .switchToLatest()
            .sink { [weak self] exchanges in
                self?.presenter.stopLoading()
                self?.presenter.updateExhanges(exchanges)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - TickersFiltersViewInteractorInterface
extension TickersFiltersInteractor: TickersFiltersViewInteractorInterface {
    func reloadExchangeList(market: MarketType) {
        let exchangesRequestObject = ExchangesRequestObject(market: market)
        exchangeListLoader.send(exchangesRequestObject)
    }

    func exchangeButtonTapped(_ exchange: Exchange) {
        presenter.dismiss(exchange)
    }
}
