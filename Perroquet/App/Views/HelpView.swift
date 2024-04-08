//
//  HelpView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 4/8/24.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject private var appVm: AppViewModel

    var body: some View {

        ScrollView(.vertical) {

            VStack(alignment: .leading, spacing: Dims.spacingRegular) {

                Text("Help!")

            } // VStack
            .frame(maxWidth: .infinity)
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .background(appVm.theme.primary)

    }
}

#Preview {
    HelpView()
}
