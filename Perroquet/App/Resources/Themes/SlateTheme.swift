//
//  SlateTheme.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/13/24.
//

import Foundation
import SwiftUI

struct SlateTheme: Theme {
    var primaryLight: Color = Color(hex: 0x3b4252)
    var primary: Color = Color(hex: 0x2e3440)
    var primaryDark: Color = Color(hex: 0x252933)

    var fontBright: Color = Color(hex: 0x4aaeff)
    var fontNormal: Color = Color(hex: 0xFFFFFF)
    var fontDim: Color = Color(hex: 0xA6A7B1)

    var colorScheme: ColorScheme = .dark
}
