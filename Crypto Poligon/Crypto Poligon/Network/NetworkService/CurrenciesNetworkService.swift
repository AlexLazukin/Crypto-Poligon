//
//  CurrenciesNetworkService.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 13.01.2023.
//

import Combine

// MARK: - CurrenciesNetworkServiceInterface
protocol CurrenciesNetworkServiceInterface {
    func requestCurrenciesCodes() -> AnyPublisher<[String: String], Never>
}

// MARK: - CurrenciesNetworkService
final class CurrenciesNetworkService: NetworkService {

    // MARK: - Private (Properties)
    private var supportedCodesStorage = CurrentValueSubject<[String: String], Never>([:])
}

// MARK: - CurrenciesNetworkServiceInterface
extension CurrenciesNetworkService: CurrenciesNetworkServiceInterface {
    func requestCurrenciesCodes() -> AnyPublisher<[String: String], Never> {
        guard supportedCodesStorage.value.isEmpty else {
            return supportedCodesStorage.eraseToAnyPublisher()
        }

        return request(.currenciesCodes, for: CurrenciesCodesResponseObject.self)
            .catch { _ -> Just<CurrenciesCodesResponseObject> in
                Just(CurrenciesCodesResponseObject(supportedCodes: []))
            }
            .map {
                var dictionary: [String: String] = [:]

                $0.supportedCodes.forEach { codes in
                    guard codes.count > 1 else { return }
                    dictionary[codes[1].lowercased()] = codes[0]
                }

                return dictionary
            }
            .handleEvents(
                receiveOutput: { [weak self] supportedCodes in
                    self?.supportedCodesStorage.send(supportedCodes)
                }
            )
            .eraseToAnyPublisher()
    }
}
