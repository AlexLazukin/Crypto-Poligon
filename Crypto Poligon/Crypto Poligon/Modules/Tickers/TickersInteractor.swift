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
            .debounce(for: .milliseconds(800), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { [weak self] tickersRequestObject in
                self?.tickersService.requestTickers(tickersRequestObject)
            }
            .switchToLatest()
            .sink { [weak self] status in
                switch status {
                case let .failure(failure):
                    self?.presenter.handleFailure(failure)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] tickers in
                self?.presenter.updateTickers(tickers)
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
}
