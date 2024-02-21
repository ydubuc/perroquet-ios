//
//  MainViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    
    @Published var currentTab: Int = 0
    
    @Published var isPresentingCreateReminderView = false
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared
    ) {
        self.appVm = appVm
        self.authMan = authMan
    }
}
