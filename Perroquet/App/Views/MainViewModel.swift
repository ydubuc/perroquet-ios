//
//  MainViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    let authMan: AuthMan
    let stash: Stash

    @Published var currentTab: Int = 0
    @Published var shouldLoadMemosView = true
    @Published var shouldLoadDiscoverView = false
    @Published var shouldLoadRequestsView = false
    @Published var shouldLoadProfileView = false

    init(
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared
    ) {
        self.authMan = authMan
        self.stash = stash
    }

    func switchToTab(_ tab: Int) {
        switch tab {
        case 0:
            shouldLoadMemosView = true
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
