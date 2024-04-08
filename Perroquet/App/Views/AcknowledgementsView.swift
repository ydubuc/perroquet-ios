//
//  AcknowledgementsView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 4/8/24.
//

import SwiftUI

struct AcknowledgementsView: View {
    @EnvironmentObject private var appVm: AppViewModel

    private let acknowledgements = [
        (
            "SimpleKeychain",
            "https://github.com/auth0/SimpleKeychain"
        ),
        (
            "SQLite.swift",
            "https://github.com/stephencelis/SQLite.swift"
        )
    ]

    var body: some View {

        ScrollView(.vertical, showsIndicators: true) {

            VStack(alignment: .center, spacing: Dims.spacingRegular) {

                ForEach(acknowledgements, id: \.0) { value in
                    AcknowledgementComponent(
                        title: value.0,
                        url: value.1,
                        theme: appVm.theme
                    )
                    .frame(maxWidth: Dims.viewMaxWidth2)
                }

            } // VStack
            .frame(maxWidth: .infinity)
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .background(appVm.theme.primary.ignoresSafeArea())
    }
}

#Preview {
    AcknowledgementsView()
        .environmentObject(AppViewModel())
}
