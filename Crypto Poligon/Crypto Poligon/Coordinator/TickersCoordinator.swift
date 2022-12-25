//
//  TickersCoordinator.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import UIKit

final class TickersCoordinator: Coordinator {

    // MARK: - Coordinator
    var rootViewController: UIViewController {
        root
    }

    // MARK: - Private (Properties)
    private let root: UINavigationController

    // MARK: - Init
    init() {
        let tickersAssembler: TickersCoordinatorAssemblerInterface = TickersAssembler()
        var tickersRouter = tickersAssembler.coordinatorRouter

        let navigationController = UINavigationController(rootViewController: tickersAssembler.rootViewController)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        navigationController.navigationBar.tintColor = UIColor(.accent)
        root = navigationController

        tickersRouter.showErrorAlert = showErrorAlert
        tickersRouter.onTickersFiltersScreen = showTickersFilters
    }

    // MARK: - Private (Properties)
    private func showTickersFilters(
        market: MarketType,
        tickersFiltersModel: TickersFiltersModel,
        completion: @escaping (TickersFiltersModel) -> Void
    ) {
        let tickersFiltersAssembler: TickersFiltersCoordinatorAssemblerInterface = TickersFiltersAssembler(
            market: market,
            tickersFiltersModel: tickersFiltersModel
        )
        let tickersFiltersViewController = tickersFiltersAssembler.rootViewController
        var tickersFiltersRouter = tickersFiltersAssembler.coordinatorRouter

        tickersFiltersRouter.showErrorAlert = showErrorAlert

        tickersFiltersRouter.dismiss = { [weak self] tickersFiltersModel in
            completion(tickersFiltersModel)
            self?.root.popViewController(animated: true)
        }

        root.pushViewController(tickersFiltersViewController, animated: true)
    }

    private func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: Strings.Alert.error, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Strings.Alert.cancel, style: .cancel)
        alertController.addAction(cancel)
        root.present(alertController, animated: true)
    }
}
