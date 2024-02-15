//
//  AuthView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var appVm: AppViewModel
    @StateObject var vm: AuthViewModel
    
    init(vm: AuthViewModel = AuthViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                    FormHeaderComponent(image: .login)
                        .frame(maxWidth: Dims.formWidthMax)
                        .frame(height: geometry.size.height * 0.33)
                        
//                    FormTextfieldComponent(
//                        text: $vm.email,
//                        placeholder: .constant("email"),
//                        theme: $appVm.theme
//                    )
//                    .frame(maxWidth: Dims.formWidthMax)
//                    
//                    FormSecureTextfieldComponent(
//                        text: $vm.passw,
//                        placeholder: .constant("password"),
//                        theme: $appVm.theme
//                    )
//                    .frame(maxWidth: Dims.formWidthMax)
                            
                    Spacer()
                    
                    Button(action: {
                        vm.signin()
                    }) {
//                        Text("Sign in with email")
                        Label("Sign in with email", image: .mail)
                            .foregroundColor(appVm.theme.fontNormal)
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(maxWidth: Dims.formWidthMax)
                            .frame(height: 50)
                            .background(appVm.theme.fontBright)
                            .cornerRadius(Dims.defaultCornerRadius)
                    }
                    
                    Rectangle()
                        .foregroundColor(appVm.theme.primaryLight)
                        .frame(maxWidth: Dims.formWidthMax)
                        .frame(height: 1)
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
                            guard let codeData = credential.authorizationCode else { return }
                            guard let authCode = String(data: codeData, encoding: .utf8) else { return }

                            print(authCode)
                            
                            vm.signinApple(authCode: authCode)
                        case .failure(let error):
                            print("Sign in with Apple failed: \(error.localizedDescription)")
                        }
                    } // SignInWithAppleButton
                    .signInWithAppleButtonStyle(appVm.theme.colorScheme == .light ? .black : .white)
                    .frame(maxWidth: Dims.formWidthMax)
                    .frame(height: 50)
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                
            } // ScrollView
            .background(appVm.theme.primary)
            
            Rectangle()
                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                .foregroundColor(appVm.theme.primary)
                .ignoresSafeArea()
            
        } // GeometryReader
        
    }
}

#Preview {
    AuthView()
        .environmentObject(AppViewModel())
}
