//
//  DarkTheme.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import SwiftUI

struct DarkTheme: Theme {
    var primaryLight: Color = Color(hex: 0x2E2F36)
    var primary: Color = Color(hex: 0x1c1d22)
    var primaryDark: Color = Color(hex: 0x111216)

    var fontBright: Color = Color(hex: 0x4AAEFF)
    var fontNormal: Color = Color(hex: 0xFFFFFF)
    var fontDim: Color = Color(hex: 0x444758)

    var colorScheme: ColorScheme = .dark

    func displayName() -> String {
        return "Dark"
    }
}
