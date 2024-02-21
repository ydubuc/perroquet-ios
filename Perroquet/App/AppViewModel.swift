//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation
import SwiftUI
import SimpleKeychain

class AppViewModel: ObservableObject {
    static let shared = AppViewModel()
    
    @Published var theme: Theme
    
    private init() {
        self.theme = DarkTheme()
    }
}
