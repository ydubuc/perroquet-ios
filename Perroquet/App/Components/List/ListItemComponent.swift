//
//  ListItemComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/29/24.
//

import SwiftUI

struct ListItemComponent: View {
    let icon: String
    let title: String
    let theme: Theme
    let onTapAction: () -> Void

    var body: some View {

        Button(action: {
            onTapAction()
        }, label: {
            HStack(alignment: .center, spacing: Dims.spacingRegular) {

                Image(systemName: icon)
                    .foregroundColor(theme.fontDim)
                    .font(.body.weight(.bold))

                Text(title)
                    .foregroundColor(theme.fontNormal)
                    .font(.body.weight(.medium))
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.forward.circle")
                    .foregroundColor(theme.fontDim)
                    .font(.body.weight(.bold))

            }
            .padding(Dims.spacingRegular)

        })

    }
}

#Preview {
    ListItemComponent(
        icon: "person.crop.circle",
        title: "Profile",
        theme: DarkTheme()
    ) {
        print("yay")
    }
}
