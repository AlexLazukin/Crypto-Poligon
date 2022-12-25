//
//  TickersFiltersPresenter.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import Combine
import Foundation

// MARK: - TickersFiltersInteractorPresenterInterface
protocol TickersFiltersInteractorPresenterInterface {
    func handleFailure(_ failure: Failure)
    func updateExhanges(_ exhanges: [Exchange])
    func startLoading()
    func stopLoading()
    func dismiss(_ exchange: Exchange)
}

// MARK: - TickersFiltersPresenter
final class TickersFiltersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersFiltersViewModel!
    private let router: TickersFiltersPresenterRouterInterface
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private let exchangesUpdater = PassthroughSubject<[Exchange], Never>()
    private let loaderUpdater = PassthroughSubject<Bool, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TickersFiltersViewModel, router: TickersFiltersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        subscribeOnFailuresHandler()
        subscribeOnExchangesUpdater()
        subscribeOnLoaderUpdater()
    }

    // MARK: - Private (Interface)
    private func subscribeOnFailuresHandler() {
        failuresHandler
            .receive(on: DispatchQueue.main)
            .sink { [weak self] failure in
                self?.router.showErrorAlert(failure.description)
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnExchangesUpdater() {
        exchangesUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.exchanges, on: viewModel)
            .store(in: &subscriptions)
    }

    private func subscribeOnLoaderUpdater() {
        loaderUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: viewModel)
            .store(in: &subscriptions)
    }
}

// MARK: - TickersFiltersInteractorPresenterInterface
extension TickersFiltersPresenter: TickersFiltersInteractorPresenterInterface {
    func handleFailure(_ failure: Failure) {
        failuresHandler.send(failure)
    }

    func updateExhanges(_ exhanges: [Exchange]) {
        exchangesUpdater.send(exhanges)
    }

    func startLoading() {
        loaderUpdater.send(true)
    }

    func stopLoading() {
        loaderUpdater.send(false)
    }

    func dismiss(_ exchange: Exchange) {
        let tickersFiltersModel = TickersFiltersModel(exchange: exchange)
        router.dismiss(tickersFiltersModel)
    }
}
