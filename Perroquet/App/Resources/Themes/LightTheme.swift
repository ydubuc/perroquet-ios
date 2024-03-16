//
//  LightTheme.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import SwiftUI

struct LightTheme: Theme {
//    var displayName: String = "Light"

    var primaryLight: Color = Color(hex: 0xFFFFFF)
    var primary: Color = Color(hex: 0xF2F2F7)
    var primaryDark: Color = Color(hex: 0xE3E3E6)

    var fontBright: Color = Color(hex: 0xFF1D6F)
    var fontNormal: Color = Color(hex: 0x1A1C23)
    var fontDim: Color = Color(hex: 0x2E303E)

    var colorScheme: ColorScheme = .light
}
