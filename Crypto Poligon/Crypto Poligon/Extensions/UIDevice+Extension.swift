//
//  UIDevice+Extension.swift
//  Crypto Poligon
//
//  Created by Alexey Lazukin on 12.01.2023.
//

import UIKit

extension UIDevice {

    // MARK: - Public (Properties)
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
