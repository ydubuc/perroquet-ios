//
//  SigninView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import SwiftUI
import AuthenticationServices

struct SigninView: View {
    @StateObject var vm: SigninViewModel
    
    init(vm: SigninViewModel) {
        _vm = StateObject(wrappedValue: vm)
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
                        theme: $vm.appVm.theme
                    )
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    FormSecureTextfieldComponent(
                        text: $vm.passw,
                        placeholder: .constant("password"),
                        theme: $vm.appVm.theme
                    )
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text(vm.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote.weight(.light))
                            .lineLimit(1)
                            .onTapGesture {
                                vm.errorMessage = ""
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            // present forgot password view
                            vm.errorMessage = "Not implemented."
                        }, label: {
                            Text("Forgot password?")
                                .foregroundColor(vm.appVm.theme.fontBright)
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
                        theme: $vm.appVm.theme
                    ) {
                        vm.signin()
                    }
                    
                    Text("or")
                        .foregroundColor(vm.appVm.theme.fontNormal)
                        .font(.body.weight(.regular))
                    
                    FormSigninAppleComponent(theme: $vm.appVm.theme) {
                        vm.requestSigninApple()
                    }
                    
                    Rectangle()
                        .foregroundColor(vm.appVm.theme.primaryLight)
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(height: 1)
                    
                    HStack(alignment: .center, spacing: Dims.spacingSmall) {
                        Text("Don't have an account?")
                            .foregroundColor(vm.appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                        
                        Button(action: {
                            // present sign up view
                            vm.errorMessage = "Not implemented."
                        }, label: {
                            Text("Sign up")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.bold))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                    }
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                
            } // ScrollView
            .background(vm.appVm.theme.primary)
            
            Rectangle()
                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                .foregroundColor(vm.appVm.theme.primary)
                .ignoresSafeArea()
            
        } // GeometryReader
        .progressBar(isPresented: $vm.isLoading)
        
    }
}

#Preview {
    SigninView(vm: SigninViewModel(appVm: AppViewModel()))
}
