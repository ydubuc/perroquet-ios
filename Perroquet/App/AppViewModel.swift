//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var theme: Theme = DarkTheme()
    
    private(set) var accessInfo: AccessInfo? = nil
    
    func onSignin(accessInfo: AccessInfo) {
        print(accessInfo)
        self.accessInfo = accessInfo
        // cache
    }
    
    func onSignout() {
        // delete cache
        self.accessInfo = nil
    }
}
