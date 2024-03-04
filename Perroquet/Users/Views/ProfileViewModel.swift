//
//  ProfileViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let authMan: AuthMan
    
    @Published var quote: String
    
    init(
        authMan: AuthMan = AuthMan.shared
    ) {
        self.authMan = authMan
        
        self.quote = Quotes.randomQuote()
    }
    
    func load() {
        quote = Quotes.randomQuote()
    }
}
