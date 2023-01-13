//
//  CurrenciesNetworkService.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 13.01.2023.
//

import Combine

// MARK: - CurrenciesNetworkServiceInterface
protocol CurrenciesNetworkServiceInterface {
    func requestCurrenciesCodes() -> AnyPublisher<CurrenciesCodesResponseObject, Failure>
}

// MARK: - CurrenciesNetworkService
final class CurrenciesNetworkService: NetworkService { }

// MARK: - CurrenciesNetworkServiceInterface
extension CurrenciesNetworkService: CurrenciesNetworkServiceInterface {
    func requestCurrenciesCodes() -> AnyPublisher<CurrenciesCodesResponseObject, Failure> {
        request(.currenciesCodes, for: CurrenciesCodesResponseObject.self)
    }
}
