//
//  ListSectionRow.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/18/24.
//

import SwiftUI

struct ListSectionRow: View {
    let icon: String
    let title: String
    let theme: Theme

    var body: some View {
        HStack(alignment: .center, spacing: Dims.spacingRegular) {

            Image(systemName: icon)

            Text(title)
                .foregroundColor(theme.fontNormal)
                .font(.body.weight(.semibold))
                .frame(width: .infinity)

        }
    }
}

#Preview {
    ListSectionRow(icon: "circle.trash", title: "Delete", theme: DarkTheme())
}
