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
}

// MARK: - TickersFiltersPresenter
final class TickersFiltersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersFiltersViewModel!
    private let router: TickersFiltersPresenterRouterInterface
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private let exchangesUpdater = PassthroughSubject<[Exchange], Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TickersFiltersViewModel, router: TickersFiltersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        subscribeOnFailuresHandler()
        subscribeOnExchangesUpdater()
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
}

// MARK: - TickersFiltersInteractorPresenterInterface
extension TickersFiltersPresenter: TickersFiltersInteractorPresenterInterface {
    func handleFailure(_ failure: Failure) {
        failuresHandler.send(failure)
    }

    func updateExhanges(_ exhanges: [Exchange]) {
        exchangesUpdater.send(exhanges)
    }
}
