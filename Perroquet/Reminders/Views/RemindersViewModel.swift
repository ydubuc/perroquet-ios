//
//  RemindersViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

class RemindersViewModel: ObservableObject {
    @Published private(set) var appVm: AppViewModel
    
    init(appVm: AppViewModel) {
        self.appVm = appVm
    }
}
