//
//  ListSectionComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/29/24.
//

import SwiftUI

struct ListSectionComponent<Content: View>: View {
    let title: String
    let theme: Theme
    let content: Content

    init(
        title: String,
        theme: Theme,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.theme = theme
        self.content = content()
    }

    var body: some View {

        VStack(alignment: .leading, spacing: Dims.spacingRegular) {

            Text(title)
                .foregroundColor(theme.fontDim)
                .font(.caption.weight(.bold))
                .lineLimit(1)

            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .background(theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)

        }

    }
}

#Preview {
    ListSectionComponent(
        title: "TEST",
        theme: DarkTheme()
    ) {

    }
}
