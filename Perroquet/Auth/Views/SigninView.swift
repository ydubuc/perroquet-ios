//
//  SigninView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import SwiftUI

struct SigninView: View {
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: SigninViewModel
    
    init(vm: StateObject<SigninViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                    FormHeaderComponent(image: .login)
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(height: geometry.size.height * 0.33)
                    
                    FormTextfieldComponent(
                        text: $vm.email,
                        placeholder: .constant("email"),
                        theme: appVm.theme
                    )
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    FormSecureTextfieldComponent(
                        text: $vm.passw,
                        placeholder: .constant("password"),
                        theme: appVm.theme
                    )
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text(vm.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote.weight(.light))
                            .lineLimit(1)
                            .onTapGesture {
                                vm.clearErrorMessage()
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            // present forgot password view
                        }, label: {
                            Text("Forgot password?")
                                .foregroundColor(appVm.theme.fontBright)
                                .font(.footnote.weight(.bold))
                                .lineLimit(1)
                        })
                    } // HStack
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    Spacer()
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(maxHeight: Dims.spacingLarge)
                    
                    FormSubmitComponent(
                        title: .constant("Sign in with email"),
                        theme: appVm.theme
                    ) {
                        vm.signin()
                    }
                    
                    Text("or")
                        .foregroundColor(appVm.theme.fontNormal)
                        .font(.body.weight(.regular))
                    
                    FormSigninAppleComponent(
                        type: .constant(.signin),
                        theme: appVm.theme
                    ) {
                        vm.requestSigninApple()
                    }
                    
                    Rectangle()
                        .foregroundColor(appVm.theme.primaryLight)
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(height: 1)
                    
                    HStack(alignment: .center, spacing: Dims.spacingSmall) {
                        Text("Don't have an account?")
                            .foregroundColor(appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                        
                        Button(action: {
                            vm.isPresentingSignupView = true
                        }, label: {
                            Text("Sign up")
                                .foregroundColor(appVm.theme.fontBright)
                                .font(.body.weight(.bold))
                                .padding(Dims.spacingSmall)
                                .background(appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        .sheet(isPresented: $vm.isPresentingSignupView) {
                            SignupView()
                                .environmentObject(appVm)
                        }
                    }
                    .frame(maxWidth: Dims.formMaxWidth)
                    
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
        .progressBar(isLoading: vm.isLoading)
        
    }
}

#Preview {
    SigninView()
}
