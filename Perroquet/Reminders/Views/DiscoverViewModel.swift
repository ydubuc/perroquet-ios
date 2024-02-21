//
//  DiscoverViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class DiscoverViewModel: ObservableObject {
    let appVm: AppViewModel
    
    init(
        appVm: AppViewModel = AppViewModel.shared
    ) {
        self.appVm = appVm
    }
}
