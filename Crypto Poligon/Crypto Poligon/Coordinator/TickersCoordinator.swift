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
    private func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: Strings.Alert.error, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Strings.Alert.cancel, style: .cancel)
        alertController.addAction(cancel)
        root.present(alertController, animated: true)
    }

    private func showTickersFilters(market: MarketType) {
        let tickersFiltersAssembler: TickersFiltersCoordinatorAssemblerInterface = TickersFiltersAssembler(
            market: market
        )
        let viewController = tickersFiltersAssembler.rootViewController

        root.pushViewController(viewController, animated: true)
    }
}
