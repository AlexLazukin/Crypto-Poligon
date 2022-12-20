//
//  TickersAssembler.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import SwiftUI

// MARK: - TickersCoordinatorAssemblerInterface
protocol TickersCoordinatorAssemblerInterface {
    var rootViewController: UIViewController { get }
    var coordinatorRouter: TickersCoordinatorRouterInterface { get set }
}

// MARK: - TickersAssembler
final class TickersAssembler: TickersCoordinatorAssemblerInterface {

    // MARK: - TickersCoordinatorAssemblerInterface
    var rootViewController: UIViewController {
        root
    }

    var coordinatorRouter: TickersCoordinatorRouterInterface

    // MARK: - Private (Properties)
    private var root: UIHostingController<TickersView>

    // MARK: - Init
    init() {
        let viewModel = TickersViewModel()
        let router = TickersRouter()
        let presenter = TickersPresenter(viewModel: viewModel, router: router)
        let interactor = TickersInteractor(presenter: presenter)
        let view = TickersView(viewModel: viewModel, interactor: interactor)

        root = UIHostingController(rootView: view)
        coordinatorRouter = router
    }
}
