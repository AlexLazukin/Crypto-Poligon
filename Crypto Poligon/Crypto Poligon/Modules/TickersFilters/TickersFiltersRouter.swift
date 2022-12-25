//
//  TickersFiltersRouter.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

// MARK: - TickersFiltersPresenterRouterInterface
protocol TickersFiltersPresenterRouterInterface {
    func showErrorAlert(_ text: String)
    func dismiss(_ tickersFiltersModel: TickersFiltersModel)
}

// MARK: - TickersFiltersCoordinatorRouterInterface
protocol TickersFiltersCoordinatorRouterInterface {
    var showErrorAlert: ((String) -> Void)? { get set }
    var dismiss: ((TickersFiltersModel) -> Void)? { get set }
}

// MARK: - TickersFiltersRouter
final class TickersFiltersRouter: TickersFiltersCoordinatorRouterInterface {

    // MARK: - TickersFiltersCoordinatorRouterInterface
    var showErrorAlert: ((String) -> Void)?
    var dismiss: ((TickersFiltersModel) -> Void)?
}

// MARK: - TickersFiltersPresenterRouterInterface
extension TickersFiltersRouter: TickersFiltersPresenterRouterInterface {
    func showErrorAlert(_ text: String) {
        showErrorAlert?(text)
    }

    func dismiss(_ tickersFiltersModel: TickersFiltersModel) {
        dismiss?(tickersFiltersModel)
    }
}
