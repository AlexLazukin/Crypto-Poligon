//
//  TickersNetworkService.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 19.12.2022.
//

import Combine

// MARK: - TickersNetworkServiceInterface
protocol TickersNetworkServiceInterface {
    func requestTickers(_ tickersRequestObject: TickersRequestObject) -> AnyPublisher<[Ticker], Failure>
}

// MARK: - TickersNetworkService
final class TickersNetworkService: NetworkService { }

// MARK: - TickersNetworkServiceInterface
extension TickersNetworkService: TickersNetworkServiceInterface {
    func requestTickers(_ tickersRequestObject: TickersRequestObject) -> AnyPublisher<[Ticker], Failure> {
        request(.tickers(tickersRequestObject), for: TickersResponseObject.self)
            .map { $0.results}
            .eraseToAnyPublisher()
    }
}
