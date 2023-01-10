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
    private let aggregatesBarLoader = PassthroughSubject<Ticker, Never>()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(presenter: TickersInteractorPresenterInterface) {
        self.presenter = presenter
        tickersService = TickersNetworkService()

        subscribeOnTickersLoader()
        subscribeOnAggregatesBarLoader()
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
                tickers.forEach { [weak self] ticker in
                    self?.aggregatesBarLoader.send(ticker)
                }
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnAggregatesBarLoader() {
        aggregatesBarLoader
            .removeDuplicates()
            .flatMap { [weak self] ticker -> AnyPublisher<(String, [BarPoint]), Never> in
                let aggregatesBarRequestObject = AggregatesBarRequestObject(ticker: ticker.ticker)

                return self?.tickersService.requestAggregatesBar(aggregatesBarRequestObject)
                    .map {
                        ($0.ticker, $0.results)
                    }
                    .catch { _ -> Just<(String, [BarPoint])> in
                        Just((ticker.ticker, []))
                    }
                    .eraseToAnyPublisher()
                ?? Just(("", [])).eraseToAnyPublisher()
            }
            .sink { [weak self] ticker, barPoints in
                self?.presenter.updateAggregatesBar(for: ticker, with: barPoints)
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
