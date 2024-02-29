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
    @Published var shouldLoadRemindersView = true
    @Published var shouldLoadDiscoverView = false
    
    @Published var isPresentingCreateReminderView = false
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared
    ) {
        self.appVm = appVm
        self.authMan = authMan
    }
    
    func switchToTab(_ tab: Int) {
        switch tab {
        case 0:
            shouldLoadRemindersView = true
        case 2:
            shouldLoadDiscoverView = true
        default:
            fatalError("Tab not implemented.")
        }
        
        currentTab = tab
    }
}
