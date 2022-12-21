//
//  TickersFiltersRouter.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

// MARK: - TickersFiltersPresenterRouterInterface
protocol TickersFiltersPresenterRouterInterface {
    func showErrorAlert(_ text: String)
}

// MARK: - TickersFiltersCoordinatorRouterInterface
protocol TickersFiltersCoordinatorRouterInterface {
    var showErrorAlert: ((String) -> Void)? { get set }
}

// MARK: - TickersFiltersRouter
final class TickersFiltersRouter: TickersFiltersCoordinatorRouterInterface {

    // MARK: - TickersFiltersCoordinatorRouterInterface
    var showErrorAlert: ((String) -> Void)?
}

// MARK: - TickersFiltersPresenterRouterInterface
extension TickersFiltersRouter: TickersFiltersPresenterRouterInterface {
    func showErrorAlert(_ text: String) {
        showErrorAlert?(text)
    }
}
