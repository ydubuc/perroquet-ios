//
//  Theme.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import SwiftUI

protocol Theme {
    var primaryLight: Color { get }
    var primary: Color { get }
    var primaryDark: Color { get }

    var fontBright: Color { get }
    var fontNormal: Color { get }
    var fontDim: Color { get }

    var colorScheme: ColorScheme { get }

    func displayName() -> String
}
