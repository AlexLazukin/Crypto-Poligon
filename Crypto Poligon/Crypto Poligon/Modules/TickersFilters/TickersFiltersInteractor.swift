//
//  TickersFiltersInteractor.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import Combine

// MARK: - TickersFiltersViewInteractorInterface
protocol TickersFiltersViewInteractorInterface { }

// MARK: - TickersFiltersInteractor
final class TickersFiltersInteractor {

    // MARK: - Private (Properties)
    private var presenter: TickersFiltersInteractorPresenterInterface
    private let tickersService: TickersNetworkServiceInterface
    private let exchangeListLoader = PassthroughSubject<Void, Never>()
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
            .compactMap { [weak self] _ in
                self?.tickersService.requestTickers(TickersRequestObject())
            }
            .switchToLatest()
            .sink { [weak self] status in
                switch status {
                case let .failure(failure):
                    self?.presenter.handleFailure(failure)
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
}

// MARK: - TickersFiltersViewInteractorInterface
extension TickersFiltersInteractor: TickersFiltersViewInteractorInterface {
    func reloadExchangeList() {
        exchangeListLoader.send()
    }
}
