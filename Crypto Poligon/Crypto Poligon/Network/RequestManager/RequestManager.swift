//
//  RequestManager.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

import Foundation

// MARK: - RequestManagerInterface
protocol RequestManagerInterface {
    func generateRequest(_ endPoint: EndPoint) throws -> URLRequest
}

// MARK: - RequestManager
final class RequestManager {

    // MARK: - Private (Properties)
    private let polygonSettings: PolygonSettings
    private let exchangeRateSettings: ExchangeRateSettings

    // MARK: - Init
    init() {
        let decoder = PropertyListDecoder()

        guard
            let polygonSettingsUrl = Bundle.main.url(forResource: "PolygonSettings", withExtension: "plist"),
            let polygonSettingsData = try? Data(contentsOf: polygonSettingsUrl),
            let polygonSettings = try? decoder.decode(PolygonSettings.self, from: polygonSettingsData),
            let exchangeRateSettingsUrl = Bundle.main.url(forResource: "ExchangeRateSettings", withExtension: "plist"),
            let exchangeRateData = try? Data(contentsOf: exchangeRateSettingsUrl),
            let exchangeRateSettings = try? decoder.decode(ExchangeRateSettings.self, from: exchangeRateData)
        else {
            fatalError(
                "PolygonSettings.plist / ExchangeRateSettings.plist wasn't detected, please, check you project settings"
            )
        }

        self.polygonSettings = polygonSettings
        self.exchangeRateSettings = exchangeRateSettings
    }
}

// MARK: - RequestManagerInterface
extension RequestManager: RequestManagerInterface {
    func generateRequest(_ endPoint: EndPoint) throws -> URLRequest {
        switch endPoint.provider {
        case .polygon: return try generatePolygonRequest(endPoint)
        case .exchangeRate: return try generateExchangeRateRequest(endPoint)
        }
    }
}

// MARK: - Private (Interface)
private extension RequestManager {
    func generatePolygonRequest(_ endPoint: EndPoint) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = polygonSettings.scheme
        urlComponents.host = polygonSettings.host

        let version = endPoint.version
        let path = endPoint.path
        let apiKey = polygonSettings.apiKey

        urlComponents.path = "/" + version + "/" + path
        urlComponents.queryItems = endPoint.parameters?.reduce(into: [], { partialResult, parameter in
            partialResult?.append(URLQueryItem(name: parameter.key, value: parameter.value))
        })

        guard let url = urlComponents.url else {
            throw Failure.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod
        urlRequest.setValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")

        print("LOG: \(url.absoluteURL)")

        return urlRequest
    }

    func generateExchangeRateRequest(_ endPoint: EndPoint) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = exchangeRateSettings.scheme
        urlComponents.host = exchangeRateSettings.host

        let version = endPoint.version
        let path = endPoint.path
        let apiKey = exchangeRateSettings.apiKey

        urlComponents.path = "/" + version + "/" + apiKey + "/" + path

        guard let url = urlComponents.url else {
            throw Failure.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod

        print("LOG: \(url.absoluteURL)")

        return urlRequest
    }
}

// MARK: - PolygonSettings
private extension RequestManager {
    struct PolygonSettings: Codable {
        var scheme: String
        var host: String
        var apiKey: String
    }
}

// MARK: - ExchangeRateSettings
private extension RequestManager {
    struct ExchangeRateSettings: Codable {
        var scheme: String
        var host: String
        var apiKey: String
    }
}
