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
    private let currenciesNetworkService: CurrenciesNetworkServiceInterface

    private let tickersLoader = PassthroughSubject<TickersRequestObject, Never>()
    private let currenciesCodesLoader = PassthroughSubject<Void, Never>()
    private let aggregatesBarLoader = PassthroughSubject<Ticker, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()

    // MARK: - Init
    init(presenter: TickersInteractorPresenterInterface) {
        self.presenter = presenter
        tickersService = TickersNetworkService()
        currenciesNetworkService = CurrenciesNetworkService()

        subscribeOnTickersLoader()
        subscribeOnAggregatesBarLoader()
        subscribeOnCurrenciesCodesLoader()
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

                self?.currenciesCodesLoader.send()
                tickers.forEach { [weak self] ticker in
                    self?.aggregatesBarLoader.send(ticker)
                }
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnCurrenciesCodesLoader() {
        currenciesCodesLoader
            .compactMap { [weak self] _ in
                self?.currenciesNetworkService.requestCurrenciesCodes()
            }
            .switchToLatest()
            .sink { [weak self] supportedCodes in
                self?.presenter.updateCurrenciesCodes(supportedCodes)
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnAggregatesBarLoader() {
        aggregatesBarLoader
            .removeDuplicates()
            .flatMap { [weak self] ticker -> AnyPublisher<(String, [BarPoint]), Never> in
                guard let self = self else {
                    return Just(("", [])).eraseToAnyPublisher()
                }

                let aggregatesBarRequestObject = self.aggregatesBarRequestObject(ticker: ticker)

                return self.tickersService.requestAggregatesBar(aggregatesBarRequestObject)
                    .map {
                        ($0.ticker, $0.results)
                    }
                    .catch { _ -> Just<(String, [BarPoint])> in
                        Just((ticker.ticker, []))
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] ticker, barPoints in
                self?.presenter.updateAggregatesBar(for: ticker, with: barPoints)
            }
            .store(in: &subscriptions)
    }

    private func aggregatesBarRequestObject(ticker: Ticker) -> AggregatesBarRequestObject {
        let currentDate = Date()
        let dateFrom = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate

        return AggregatesBarRequestObject(
            ticker: ticker.ticker,
            multiplier: 10,
            timespan: .minute,
            dateFrom: dateFormatter.string(from: dateFrom),
            dateTo: dateFormatter.string(from: currentDate)
        )
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
