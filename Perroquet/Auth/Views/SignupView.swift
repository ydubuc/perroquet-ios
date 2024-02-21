//
//  SignupView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import SwiftUI

struct SignupView: View {
    @StateObject var vm: SignupViewModel
    
    init(vm: StateObject<SignupViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                    FormHeaderComponent(image: .register)
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(height: geometry.size.height * 0.33)
                    
                    FormTextfieldComponent(
                        text: $vm.email,
                        placeholder: .constant("email"),
                        theme: vm.appVm.theme
                    )
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    FormSecureTextfieldComponent(
                        text: $vm.passw,
                        placeholder: .constant("password"),
                        theme: vm.appVm.theme
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
                        
                    } // HStack
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    Spacer()
                        .frame(maxWidth: Dims.formMaxWidth)
                        .frame(maxHeight: Dims.spacingLarge)
                    
                    Button(action: {
                        vm.isPresentingSafariView = true
                    }, label: {
                        Text("By signing up, you agree to the terms")
                            .foregroundColor(vm.appVm.theme.fontBright)
                            .font(.footnote.weight(.regular))
                            .frame(maxWidth: Dims.formMaxWidth)
                    })
                    .sheet(isPresented: $vm.isPresentingSafariView) {
                        SafariView(url: URL(string: Config.TERMS_URL)!, theme: vm.appVm.theme)
                            .ignoresSafeArea(.all)
                    }
                    
                    FormSubmitComponent(
                        title: .constant("Sign up with email"),
                        theme: vm.appVm.theme
                    ) {
                        vm.signup()
                    }
                    
                    Text("or")
                        .foregroundColor(vm.appVm.theme.fontNormal)
                        .font(.body.weight(.regular))
                        .frame(maxWidth: Dims.formMaxWidth)
                    
                    FormSigninAppleComponent(
                        type: .constant(.signup),
                        theme: vm.appVm.theme
                    ) {
                        vm.requestSigninApple()
                    }
                    
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
        .progressBar(isLoading: vm.isLoading)
        
    }
}

#Preview {
    SignupView()
}
