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
    let stash: Stash
    
    @Published var currentTab: Int = 0
    @Published var shouldLoadRemindersView = true
    @Published var shouldLoadDiscoverView = false
    @Published var shouldLoadRequestsView = false
    @Published var shouldLoadProfileView = false
    
    @Published var isPresentingCreateReminderView = false
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.stash = stash
    }
    
    func switchToTab(_ tab: Int) {
        switch tab {
        case 0:
            shouldLoadRemindersView = true
        case 1:
            shouldLoadDiscoverView = true
        case 3:
            shouldLoadRequestsView = true
        case 4:
            shouldLoadProfileView = true
        default:
            fatalError("Tab not implemented.")
        }
        
        currentTab = tab
    }
}
