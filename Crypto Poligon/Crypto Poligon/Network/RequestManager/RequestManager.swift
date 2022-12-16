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
    private let apiSettings: ApiSettings

    // MARK: - Init
    init() {
        let decoder = PropertyListDecoder()

        guard
            let url = Bundle.main.url(forResource: "ApiSettings", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let apiSettings = try? decoder.decode(ApiSettings.self, from: data)
        else {
            fatalError("ApiSettings.plist wasn't detected, please, check you project settings")
        }

        self.apiSettings = apiSettings
    }
}

// MARK: - RequestManagerInterface
extension RequestManager: RequestManagerInterface {
    func generateRequest(_ endPoint: EndPoint) throws -> URLRequest {
        let scheme = apiSettings.scheme
        let host = apiSettings.host
        let version = endPoint.version
        let path = endPoint.path
        let apiKey = apiSettings.apiKey
        let stringUrl = scheme + host + "/" + version + "/" + path

        guard let url = URL(string: stringUrl) else {
            throw Failure.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod
        urlRequest.setValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}

// MARK: - ApiSettings
private extension RequestManager {
    struct ApiSettings: Codable {
        var scheme: String
        var host: String
        var apiKey: String
    }
}
