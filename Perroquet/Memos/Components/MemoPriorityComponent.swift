//
//  MemoPriorityComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/20/24.
//

import SwiftUI

struct MemoPriorityComponent: View {
    @Binding var priority: String
    let theme: Theme

    var body: some View {
        Menu {
            Button {
                priority = ""
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
            Text("\(priority.isEmpty ? "Priority" : priority.capitalized)")
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
        priority: .constant("high"),
        theme: DarkTheme()
    )
}
