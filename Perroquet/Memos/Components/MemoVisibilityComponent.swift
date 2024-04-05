//
//  MemoVisibilityComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 4/5/24.
//

import SwiftUI

struct MemoVisibilityComponent: View {
    @Binding var visibility: Int
    let theme: Theme

    var body: some View {

        Button(action: {
            visibility = visibility == Memo.Visibility.priv.rawValue ? Memo.Visibility.pub.rawValue : Memo.Visibility.priv.rawValue
        }, label: {
            Text(visibility == Memo.Visibility.priv.rawValue ? "Private" : "Public")
                .foregroundColor(visibility == 0 ? theme.fontDim : theme.fontNormal)
                .font(.body.weight(.medium))
                .padding(Dims.spacingSmall)
                .background(theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
        })

    }
}

#Preview {
    MemoVisibilityComponent(
        visibility: .constant(1),
        theme: DarkTheme()
    )
}
