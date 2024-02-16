//
//  FormSigninAppleComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import SwiftUI

struct FormSigninAppleComponent: View {
    @Binding var theme: Theme
    let onTapAction: () -> ()
    
    var body: some View {
        
        Button(action: {
            onTapAction()
        }, label: {
            
            HStack(alignment: .center, spacing: Dims.spacingSmall) {
                
                Image(systemName: "apple.logo")
                    .foregroundColor(theme.colorScheme == .light ? .white : .black)
                    .font(.footnote)
                
                Text("Sign in with Apple")
                    .foregroundColor(theme.colorScheme == .light ? .white : .black)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
            }
            .padding(Dims.spacingRegular)
            .frame(maxWidth: Dims.formMaxWidth)
            .background(theme.colorScheme == .light ? .black : .white)
            .cornerRadius(Dims.cornerRadius)
        })
        
    }
}

#Preview {
    FormSigninAppleComponent(
        theme: .constant(DarkTheme())
    ) {
        print("sign in with apple")
    }
}
