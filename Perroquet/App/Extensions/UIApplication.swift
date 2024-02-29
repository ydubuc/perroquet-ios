//
//  UIApplication.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/28/24.
//

import Foundation
import UIKit
import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    static func setWindowBackgroundColor(_ color: UIColor) {
//        if let windowScene = self.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first
//        {
//            window.backgroundColor = color
//        }
        if let keyWindow = self.shared.keyWindow {
            keyWindow.backgroundColor = color
        }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
