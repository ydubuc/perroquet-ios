//
//  FormSigninAppleComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import SwiftUI

struct FormSigninAppleComponent: View {
    enum TitleType: String {
        case signin = "Sign in with Apple"
        case signup = "Sign up with Apple"
        case continueApple = "Continue with Apple"
    }

    @Binding var type: TitleType
    let theme: Theme
    let onTapAction: () -> ()
    
    var body: some View {
        
        Button(action: {
            onTapAction()
        }, label: {
            
            HStack(alignment: .center, spacing: Dims.spacingSmall) {
                
                Image(systemName: "apple.logo")
                    .foregroundColor(theme.colorScheme == .light ? .white : .black)
                    .font(.footnote)
                
                Text(type.rawValue)
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
        type: .constant(.signin),
        theme: DarkTheme()
    ) {
        print("sign in with apple")
    }
}
