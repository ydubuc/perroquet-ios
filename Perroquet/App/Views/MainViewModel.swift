//
//  MainViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published private(set) var appVm: AppViewModel
    @Published var currentTab = 0
    
    init(appVm: AppViewModel) {
        self.appVm = appVm
    }
}
