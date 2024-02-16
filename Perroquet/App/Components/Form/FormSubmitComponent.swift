//
//  FormSubmitComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import SwiftUI

struct FormSubmitComponent: View {
    @Binding var title: String
    @Binding var theme: Theme
    let onTapAction: () -> ()
    
    var body: some View {
        
        Button(action: {
            onTapAction()
        }, label: {
            Text(title)
                .foregroundColor(theme.fontNormal)
                .font(.body.weight(.bold))
                .lineLimit(1)
                .padding(Dims.spacingRegular)
                .frame(maxWidth: Dims.formMaxWidth)
                .background(theme.fontBright)
                .cornerRadius(Dims.cornerRadius)
        })
        
    }
}

#Preview {
    FormSubmitComponent(title: .constant("Test"), theme: .constant(DarkTheme())) {
        print("test")
    }
}
