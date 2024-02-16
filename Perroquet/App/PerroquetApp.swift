//
//  PerroquetApp.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

@main
struct PerroquetApp: App {
    @StateObject var appVm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appVm.accessInfo != nil {
                MainView()
            } else {
                SigninView(vm: SigninViewModel(appVm: appVm))
            }
        }
    }
}
