//
//  TickersRouter.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

// MARK: - TickersPresenterRouterInterface
protocol TickersPresenterRouterInterface {
    func showErrorAlert(_ text: String)
    func showTickersFiltersScreen(market: MarketType)
}

// MARK: - TickersCoordinatorRouterInterface
protocol TickersCoordinatorRouterInterface {
    var showErrorAlert: ((String) -> Void)? { get set }
    var onTickersFiltersScreen: ((MarketType) -> Void)? { get set }
}

// MARK: - TickersRouter
final class TickersRouter: TickersCoordinatorRouterInterface {

    // MARK: - TickersCoordinatorRouterInterface
    var showErrorAlert: ((String) -> Void)?
    var onTickersFiltersScreen: ((MarketType) -> Void)?
}

// MARK: - TickersPresenterRouterInterface
extension TickersRouter: TickersPresenterRouterInterface {
    func showErrorAlert(_ text: String) {
        showErrorAlert?(text)
    }

    func showTickersFiltersScreen(market: MarketType) {
        onTickersFiltersScreen?(market)
    }
}
