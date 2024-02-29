//
//  FormTextfieldMultilineComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/26/24.
//

import SwiftUI

struct FormTextfieldMultilineComponent: View {
    @Binding var text: String
    @Binding var title: String
    @Binding var placeholder: String
    let theme: Theme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Dims.spacingSmall) {
            
            Text(title.uppercased())
                .foregroundColor(theme.fontDim)
                .font(.footnote.weight(.bold))
            
            ZStack {
                
                Text(text)
                    .font(.body.weight(.regular))
                    .padding(Dims.spacingRegular)
                    .opacity(0)
                
                TextField("", text: $text, axis: .vertical)
                    .foregroundColor(theme.fontNormal)
                    .font(.body.weight(.regular))
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                    }
                    .padding(Dims.spacingRegular)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.leading)
                
            }
            .background(theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)
            
        } // VStack
        
    }
}

#Preview {
    FormTextfieldMultilineComponent(
        text: .constant("Testing Testing One Two Check, One Two Check, Testing Testing Testing Testing One Two Check, One Two Check, Testing Testing Testing Testing One Two Check, One Two Check, Testing Testing"),
        title: .constant("test"),
        placeholder: .constant("test"),
        theme: DarkTheme()
    )
}
