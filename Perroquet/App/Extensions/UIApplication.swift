//
//  UIApplication.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/28/24.
//

import Foundation
import UIKit

extension UIApplication {
    static func setWindowBackgroundColor(_ color: UIColor) {
        if let windowScene = self.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first
        {
            window.backgroundColor = color
        }
    }
}
