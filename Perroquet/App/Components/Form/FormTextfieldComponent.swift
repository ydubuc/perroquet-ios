//
//  FormTextfieldComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import SwiftUI

struct FormTextfieldComponent: View {
    @Binding var text: String
    @Binding var placeholder: String
    @Binding var theme: Theme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Dims.spacingSmall) {
            
            Text(placeholder.uppercased())
                .font(.caption)
                .foregroundColor(theme.fontDim)
            
            HStack(alignment: .center, spacing: 0) {
                
                TextField("", text: $text)
                    .font(.body)
                    .foregroundColor(theme.fontNormal)
                    .lineLimit(1)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .font(.body)
                            .foregroundColor(theme.fontDim)
                            .lineLimit(1)
                    }
                    .padding(Dims.spacingRegular)
                
                if !text.isEmpty {
                    Button {
                        text.removeAll()
                    } label: {
                        Image(.cancel)
                            .renderingMode(.template)
                            .font(.body)
                            .foregroundColor(theme.fontDim)
                            .padding(Dims.spacingRegular)
                    }
                }
                
            } // HStack
            .background(theme.primaryDark)
            .cornerRadius(Dims.defaultCornerRadius)
            
        } // VStack
        
    }
}

#Preview {
    FormTextfieldComponent(
        text: .constant("Test"),
        placeholder: .constant("Testing"),
        theme: .constant(DarkTheme())
    )
}
