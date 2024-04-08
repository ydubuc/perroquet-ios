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

    @Published var isPresentingAccountView = false
    @Published var isPresentingDevicesView = false

    @Published var isPresentingAppearanceView = false

    @Published var isPresentingHelpView = false
    @Published var isPresentingSupportView = false

    @Published var isPresentingPrivacyView = false
    @Published var isPresentingTermsView = false
    @Published var isPresentingAcknowledgementsView = false

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
