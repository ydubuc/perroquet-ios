//
//  MemoPriorityComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/20/24.
//

import SwiftUI

struct MemoPriorityComponent: View {
    @Binding var priority: Int
    let theme: Theme

    var body: some View {
        Menu {
            Button {
                priority = 0
            } label: {
                Text("None")
            }

            Button {
                priority = Memo.Priority.high.rawValue
            } label: {
                Text("High")
            }

            Button {
                priority = Memo.Priority.medium.rawValue
            } label: {
                Text("Medium")
            }

            Button {
                priority = Memo.Priority.low.rawValue
            } label: {
                Text("Low")
            }
        } label: {
            Text("\(Memo.Priority.displayName(value: priority))")
                .foregroundColor(theme.fontBright)
                .font(.body.weight(.medium))
                .padding(Dims.spacingSmall)
                .background(theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
        }
    }
}

#Preview {
    MemoPriorityComponent(
        priority: .constant(2),
        theme: DarkTheme()
    )
}
