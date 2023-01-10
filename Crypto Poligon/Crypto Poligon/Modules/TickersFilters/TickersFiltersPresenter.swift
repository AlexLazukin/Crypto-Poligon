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
    func updateTickersFiltersModel(_ exchange: Exchange)
    func dismiss(_ tickersFiltersModel: TickersFiltersModel)
}

// MARK: - TickersFiltersPresenter
final class TickersFiltersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersFiltersViewModel!
    private let router: TickersFiltersPresenterRouterInterface
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private let exchangesUpdater = PassthroughSubject<[Exchange], Never>()
    private let loaderUpdater = PassthroughSubject<Bool, Never>()
    private let tickersFiltersUpdater = PassthroughSubject<TickersFiltersModel, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TickersFiltersViewModel, router: TickersFiltersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        subscribeOnFailuresHandler()
        subscribeOnExchangesUpdater()
        subscribeOnLoaderUpdater()
        subscribeOnTickersFiltersUpdater()
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
        exchangesUpdater.assign(to: \.exchanges, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnLoaderUpdater() {
        loaderUpdater.assign(to: \.isLoading, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnTickersFiltersUpdater() {
        tickersFiltersUpdater.assign(to: \.tickersFiltersModel, on: viewModel, subscriptions: &subscriptions)
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

    func updateTickersFiltersModel(_ exchange: Exchange) {
        var tickersFiltersModel = viewModel.tickersFiltersModel
        tickersFiltersModel.exchange = exchange != tickersFiltersModel.exchange ? exchange : nil
        tickersFiltersUpdater.send(tickersFiltersModel)
    }

    func dismiss(_ tickersFiltersModel: TickersFiltersModel) {
        router.dismiss(tickersFiltersModel)
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
