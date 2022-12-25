//
//  NetworkService.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

import Foundation
import Combine

class NetworkService {

    // MARK: - Private (Properties)
    private let requestManager: RequestManagerInterface
    private let decoder: JSONDecoder

    // MARK: - Init
    init() {
        self.requestManager = RequestManager()

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: - Public (Interfaces)
    func request<Object: Decodable>(_ endPoint: EndPoint, for object: Object.Type) -> AnyPublisher<Object, Failure> {
        dataTaskPublisher(endPoint)
            .tryMap { [weak self] data throws -> Data in
                if let error = try? self?.decoder.decode(ResponseError.self, from: data) {
                    throw Failure.apiError(reason: error.error)
                }

                return data
            }
            .decode(type: Object.self, decoder: decoder)
            .mapError { [weak self] error in
                self?.mapError(error) ?? .unknown
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private (Interfaces)
private extension NetworkService {
    func dataTaskPublisher(_ endPoint: EndPoint) -> AnyPublisher<Data, Error> {
        do {
            let request = try requestManager.generateRequest(endPoint)

            return URLSession.DataTaskPublisher(request: request, session: .shared)
                .tryMap { data, _ in
                    // print("Response data: \(String(describing: try? JSONSerialization.jsonObject(with: data)))")

                    return data
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func mapError(_ error: Error) -> Failure {
        if let error = error as? Failure {
            return error
        } else if let error = error as? DecodingError {
            switch error {
            case let .typeMismatch(type, context), let .valueNotFound(type, context):
                let details = decodingErrorDetails(context: context)
                return .decodingError(reason: "\(context.debugDescription) (type: \(type), \(details))")
            case let .keyNotFound(key, context):
                let details = decodingErrorDetails(context: context)
                return .decodingError(reason: "\(context.debugDescription) (key: \(key), \(details))")
            case let .dataCorrupted(context):
                let details = decodingErrorDetails(context: context)
                return .decodingError(reason: "\(context.debugDescription) - (\(details))")
            @unknown default:
                fatalError("Handling of DecodingError should be supplemented with new cases")
            }
        } else if let error = error as? URLError {
            return .apiError(reason: error.localizedDescription)
        } else {
            return .unknown
        }
    }

    func decodingErrorDetails(context: DecodingError.Context) -> String {
        context.underlyingError?.localizedDescription
        ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
    }
}
