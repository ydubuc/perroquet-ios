//
//  ListItemOptionComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/29/24.
//

import SwiftUI

struct ListItemOptionComponent: View {
    let title: String
    let value: String
    let options: [(String, () -> Void)]
    let theme: Theme

    var body: some View {

        HStack(alignment: .center, spacing: Dims.spacingRegular) {

            Text(title)
                .foregroundColor(theme.fontNormal)
                .font(.body.weight(.medium))
                .lineLimit(1)

            Spacer()

            Menu {
                ForEach(options, id: \.0) { option in
                    Button(action: {
                        option.1()
                    }, label: {
                        Text(option.0)
                    })
                }
            } label: {
                Text(value)
                    .foregroundColor(theme.fontDim)
                    .font(.body.weight(.bold))
            }

        }
        .padding(Dims.spacingRegular)

    }
}

#Preview {
    ListItemOptionComponent(
        title: "Test",
        value: "Testing",
        options: [("Test 1", {}), ("Test 2", {})],
        theme: DarkTheme()
    )
}
