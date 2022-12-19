//
//  TickersCoordinator.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import UIKit

final class TickersCoordinator {

    // MARK: - Private (Properties)
    private var root: UINavigationController

    // MARK: - Init
    init() {
        let ticketsViewController = ViewController()
        root = UINavigationController(rootViewController: ticketsViewController)
    }

    // MARK: - Public (Properties)
    func rootViewController() -> UIViewController {
        root
    }
}
