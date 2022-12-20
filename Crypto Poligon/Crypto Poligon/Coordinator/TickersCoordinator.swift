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
    private var tickersAssembler: TickersCoordinatorAssemblerInterface

    // MARK: - Init
    init() {
        tickersAssembler = TickersAssembler()
        root = UINavigationController(rootViewController: tickersAssembler.rootViewController)

        tickersAssembler.coordinatorRouter.showErrorAlert = showErrorAlert
    }

    // MARK: - Private (Properties)
    private func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: Strings.Alert.error, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Strings.Alert.cancel, style: .cancel)
        alertController.addAction(cancel)
        root.present(alertController, animated: true)
    }
}
