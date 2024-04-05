//
//  Themes.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

enum Themes: String, CaseIterable {
    static var key: String = "theme"

    case slate = "theme_slate"
    case dark = "theme_dark"
    case light = "theme_light"

    func value() -> Theme {
        switch self {
        case .slate:
            return SlateTheme()
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
