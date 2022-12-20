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
}

// MARK: - TickersPresenter
final class TickersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersViewModel!
    private let router: TickersPresenterRouterInterface
    private let tickersUpdater = PassthroughSubject<[Ticker], Never>()
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TickersViewModel, router: TickersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        subscribeOnTickersUpdater()
        subscribeOnFailuresHandler()
    }

    // MARK: - Private (Interface)
    private func subscribeOnTickersUpdater() {
        tickersUpdater
            .receive(on: DispatchQueue.main)
            .assign(to: \.tickers, on: viewModel)
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
}

// MARK: - TickersInteractorPresenterInterface
extension TickersPresenter: TickersInteractorPresenterInterface {
    func updateTickers(_ tickers: [Ticker]) {
        tickersUpdater.send(tickers)
    }

    func handleFailure(_ failure: Failure) {
        failuresHandler.send(failure)
    }
}
