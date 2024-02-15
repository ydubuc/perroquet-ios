//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    @Published var theme: Theme = DarkTheme()
}
