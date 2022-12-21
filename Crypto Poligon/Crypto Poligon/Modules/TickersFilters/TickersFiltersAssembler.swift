//
//  TickersFiltersAssembler.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 21.12.2022.
//

import SwiftUI

// MARK: - TickersFiltersCoordinatorAssemblerInterface
protocol TickersFiltersCoordinatorAssemblerInterface {
    var rootViewController: UIViewController { get }
    var coordinatorRouter: TickersFiltersCoordinatorRouterInterface { get set }
}

// MARK: - TickersFiltersAssembler
final class TickersFiltersAssembler: TickersFiltersCoordinatorAssemblerInterface {

    // MARK: - TickersFiltersCoordinatorAssemblerInterface
    var rootViewController: UIViewController {
        root
    }

    var coordinatorRouter: TickersFiltersCoordinatorRouterInterface

    // MARK: - Private (Properties)
    private var root: UIHostingController<TickersFiltersView>

    // MARK: - Init
    init() {
        let viewModel = TickersFiltersViewModel()
        let router = TickersFiltersRouter()
        let presenter = TickersFiltersPresenter(viewModel: viewModel, router: router)
        let interactor = TickersFiltersInteractor(presenter: presenter)
        let view = TickersFiltersView(viewModel: viewModel, interactor: interactor)

        root = UIHostingController(rootView: view)
        coordinatorRouter = router
    }
}
