//
//  Strings.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 16.12.2022.
//

// MARK: - Strings
final class Strings { }

// MARK: - NetworkError
extension Strings {
    final class NetworkError {

        // MARK: - Public (Properties)
        static let invalidUrl = "Invalid Url Address"
        static let encodingFailed = "Encoding of parameters of json was failed"
        static let unknown = "Unknown Error"
    }
}

// MARK: - Alert
extension Strings {
    final class Alert {

        // MARK: - Public (Properties)
        static let error = "Error"
        static let cancel = "Cancel"
    }
}

// MARK: - UIElements
extension Strings {
    final class UIElements {

        // MARK: - Public (Properties)
        static let search = "Search"
    }
}

// MARK: - Tickers
extension Strings {
    final class Tickers {

        // MARK: - Public (Properties)
        static let notFound = "Nothing found. Try changing the request parameters."
        static let filtersTitle = "Filters"
        static let save = "Save"
        static let exchanges = "Exchanges"
        static let exchangesNotFound = "Exchanges not found"
        static let seeMore = "See more"
        static let collapseBack = "Collapse back"
    }
}
