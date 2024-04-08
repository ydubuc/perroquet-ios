//
//  AcknowledgementComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 4/8/24.
//

import SwiftUI

struct AcknowledgementComponent: View {
    let title: String
    let url: String
    let theme: Theme

    @State var isPresentingSafariView = false

    var body: some View {

        Button {
            isPresentingSafariView = true
        } label: {
            HStack(alignment: .center, spacing: Dims.spacingRegular) {

                VStack(alignment: .leading, spacing: Dims.spacingSmall) {

                    Text(title)
                        .foregroundColor(theme.fontNormal)
                        .font(.body.weight(.regular))
                        .lineLimit(1)

                    Text(url)
                        .foregroundColor(theme.fontBright)
                        .font(.caption2.weight(.regular))
                        .lineLimit(1)

                }

                Spacer()

                Image(systemName: "chevron.forward.circle")
                    .foregroundColor(theme.fontDim)
                    .font(.body.weight(.bold))

            } // HStack
            .sheet(isPresented: $isPresentingSafariView) {
                SafariView(url: URL(string: url)!, theme: theme)
                    .ignoresSafeArea(.all)
            }
        }

    }
}

#Preview {
    AcknowledgementComponent(
        title: "Perroquet",
        url: "https://perroquet.beamcove.com",
        theme: DarkTheme()
    )
}
