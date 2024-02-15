//
//  Themes.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

enum Themes: String, CaseIterable {
    static var key: String = "theme"
//    static var defaultRawValue: String = Themes.dark.rawValue
//    static var displayNames: [String] = Themes.allCases.map { $0.displayName() }

    case dark = "theme_dark"
    case light = "theme_light"

    func value() -> Theme {
        switch self {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }

    func displayName() -> String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
