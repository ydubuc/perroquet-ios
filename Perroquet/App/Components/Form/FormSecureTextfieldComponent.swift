//
//  FormSecureTextfieldComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import SwiftUI

struct FormSecureTextfieldComponent: View {
    @Binding var text: String
    @Binding var placeholder: String
    let theme: Theme

    var body: some View {

        VStack(alignment: .leading, spacing: Dims.spacingSmall) {

            Text(placeholder.uppercased())
                .foregroundColor(theme.fontDim)
                .font(.footnote.weight(.bold))

            HStack(alignment: .center, spacing: 0) {

                SecureField("", text: $text)
                    .foregroundColor(theme.fontNormal)
                    .font(.footnote.weight(.regular))
                    .lineLimit(1)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                    }
                    .padding(Dims.spacingRegular)
                    .disableAutocorrection(true)

                if !text.isEmpty {
                    Button {
                        text.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(theme.fontDim)
                            .font(.body.weight(.regular))
                            .padding(Dims.spacingRegular)
                    }
                }

            } // HStack
            .background(theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)

        } // VStack

    }
}

#Preview {
    FormSecureTextfieldComponent(
        text: .constant("Test"),
        placeholder: .constant("Testing"),
        theme: DarkTheme()
    )
}
