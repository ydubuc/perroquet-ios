//
//  ProfileViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    
    @Published var quote: String
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared
    ) {
        self.appVm = appVm
        self.authMan = authMan
        
        self.quote = Quotes.randomQuote()
    }
    
    func load() {
        quote = Quotes.randomQuote()
    }
}
