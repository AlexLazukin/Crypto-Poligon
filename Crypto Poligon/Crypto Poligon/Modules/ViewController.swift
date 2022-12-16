//
//  ViewController.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var subscriptions = Set<AnyCancellable>()
    let service = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed

        service.request(.tickers, for: TickersResponseObject.self)
            .receive(on: DispatchQueue.main)
            .sink { status in
                switch status {
                case let .failure(error):
                    print(error.description)
                case .finished:
                    break
                }
            } receiveValue: { tickersResponseObject in
                print(tickersResponseObject.results.count)
            }
            .store(in: &subscriptions)
    }
}
