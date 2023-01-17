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
    func updateAggregatesBar(with aggregatesBarResponseObject: AggregatesBarResponseObject)
    func updateCurrenciesCodes(_ codes: [String: String])
    func handleFailure(_ failure: Failure)
    func changeMarket(market: MarketType)
    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel)
    func startLoading()
    func stopLoading()
    func currentExchangeTapped()
}

// MARK: - TickersPresenter
final class TickersPresenter {

    // MARK: - Private (Properties)
    private weak var viewModel: TickersViewModel!
    private let router: TickersPresenterRouterInterface
    private let tickersUpdater = PassthroughSubject<[Ticker], Never>()
    private let marketUpdater = PassthroughSubject<MarketType, Never>()
    private let failuresHandler = PassthroughSubject<Failure, Never>()
    private let loaderUpdater = PassthroughSubject<Bool, Never>()
    private let tickersFiltersUpdater = PassthroughSubject<TickersFiltersModel, Never>()
    private let barPointsUpdater = PassthroughSubject<AggregatesBarResponseObject, Never>()
    private let currenciesCodesUpdater = PassthroughSubject<[String: String], Never>()
    private var subscriptions = Set<AnyCancellable>()

    private let numberFormatterHub: NumberFormatterHub
    private var currenciesCodes: [String: String]

    // MARK: - Init
    init(viewModel: TickersViewModel, router: TickersPresenterRouterInterface) {
        self.viewModel = viewModel
        self.router = router

        currenciesCodes = [:]
        numberFormatterHub = NumberFormatterHub.shared

        subscribeOnTickersUpdater()
        subscribeOnMarketUpdater()
        subscribeOnFailuresHandler()
        subscribeOnLoaderUpdater()
        subscribeOnTickersFiltersUpdater()
        subscribeOnBarPointsUpdater()
        subscribeOnCurrenciesCodesUpdater()
    }

    // MARK: - Private (Interface)
    private func subscribeOnTickersUpdater() {
        tickersUpdater
            .map {
                $0.map { ticker in
                    TickerRowModel(
                        ticker: ticker.ticker,
                        name: ticker.name,
                        currencyName: ticker.currencyName
                    )
                }
            }
            .assign(to: \.tickersModels, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnMarketUpdater() {
        marketUpdater.assign(to: \.currentMarket, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnFailuresHandler() {
        failuresHandler
            .receive(on: DispatchQueue.main)
            .sink { [weak self] failure in
                self?.router.showErrorAlert(failure.description)
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnLoaderUpdater() {
        loaderUpdater.assign(to: \.isLoading, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnTickersFiltersUpdater() {
        tickersFiltersUpdater.assign(to: \.tickersFiltersModel, on: viewModel, subscriptions: &subscriptions)
    }

    private func subscribeOnBarPointsUpdater() {
        barPointsUpdater
            .receive(on: DispatchQueue.main)
            .sink { [weak self] aggregatesBarResponseObject in
                guard let self = self else { return }

                let barPoints = aggregatesBarResponseObject.results

                self.viewModel.tickersModels = self.viewModel.tickersModels.map {
                    $0.ticker == aggregatesBarResponseObject.ticker
                    ? TickerRowModel(
                        ticker: $0.ticker,
                        name: $0.name,
                        currencyName: $0.currencyName,
                        status: aggregatesBarResponseObject.status,
                        barPoints: barPoints,
                        position: self.convert(
                            position: barPoints?.last?.close ?? .zero,
                            currencyName: $0.currencyName
                        ),
                        changeValue: self.calculateChangeValue(by: barPoints)
                    )
                    : $0
                }
            }
            .store(in: &subscriptions)
    }

    private func subscribeOnCurrenciesCodesUpdater() {
        currenciesCodesUpdater.assign(to: \.currenciesCodes, on: self, subscriptions: &subscriptions)
    }
}

private extension TickersPresenter {
    func calculateChangeValue(by barPoints: [BarPoint]?) -> String {
        let first = barPoints?.first?.value ?? .zero
        let last = barPoints?.last?.value ?? .zero

        guard last != .zero else {
            return numberFormatterHub.changesFormatter.string(from: 0) ?? ""
        }

        let change = (last - first) / last

        return numberFormatterHub.changesFormatter.string(from: NSNumber(value: change)) ?? ""
    }

    func convert(position: Decimal, currencyName: String) -> String {
        guard position != .zero else { return "" }
        numberFormatterHub.currencyFormatter.currencyCode = currenciesCodes[currencyName.lowercased()] ?? currencyName
        let value = NSNumber(value: NSDecimalNumber(decimal: position).doubleValue)
        return numberFormatterHub.currencyFormatter.string(from: value) ?? ""
    }
}

// MARK: - TickersInteractorPresenterInterface
extension TickersPresenter: TickersInteractorPresenterInterface {
    func updateTickers(_ tickers: [Ticker]) {
        tickersUpdater.send(tickers)
    }

    func updateAggregatesBar(with aggregatesBarResponseObject: AggregatesBarResponseObject) {
        barPointsUpdater.send(aggregatesBarResponseObject)
    }

    func updateCurrenciesCodes(_ codes: [String: String]) {
        currenciesCodesUpdater.send(codes)
    }

    func handleFailure(_ failure: Failure) {
        failuresHandler.send(failure)
    }

    func changeMarket(market: MarketType) {
        marketUpdater.send(market)
    }

    func filtersTapped(market: MarketType, tickersFiltersModel: TickersFiltersModel) {
        router.showTickersFiltersScreen(
            market: market,
            tickersFiltersModel: tickersFiltersModel
        ) { [weak self] tickersFiltersModel in
            self?.viewModel.tickersFiltersModel = tickersFiltersModel
        }
    }

    func startLoading() {
        loaderUpdater.send(true)
    }

    func stopLoading() {
        loaderUpdater.send(false)
    }

    func currentExchangeTapped() {
        var tickersFiltersModel = viewModel.tickersFiltersModel
        tickersFiltersModel.exchange = nil
        tickersFiltersUpdater.send(tickersFiltersModel)
    }
}

private extension Publisher where Failure == Never {
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
