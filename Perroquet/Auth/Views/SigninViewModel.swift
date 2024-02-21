//
//  SigninViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

class SigninViewModel: NSObject, ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    let authService: AuthService
    
    @Published var email: String = ""
    @Published var passw: String = ""
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    @Published var isPresentingSignupView = false
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        authService: AuthService = AuthService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.authService = authService
    }
    
    func lock(_ state: Bool) {
        switch state {
        case true:
            isLoading = true
            clearErrorMessage()
        case false:
            isLoading = false
        }
    }
    
    func clearErrorMessage() {
        errorMessage = ""
    }

    func signin() {
        lock(true)
        
        let email = email
        let passw = passw
        
        let dto = SigninDto(email: email, passw: passw)
        
        Task {
            let result = await authService.signin(dto: dto)
            
            DispatchQueue.main.async {
                self.lock(false)
                
                switch result {
                case .success(let accessInfo):
                    self.authMan.onSignin(accessInfo: accessInfo)
                case .failure(let apiError):
                    print(apiError.localizedDescription)
                    self.errorMessage = apiError.message
                }
            }
        }
    }
    
    func requestSigninApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    private func signinApple(authCode: String) {
        lock(true)
        
        let dto = SigninAppleDto(authCode: authCode)
        
        Task {
            let result = await authService.signinApple(dto: dto)
            
            DispatchQueue.main.async {
                self.lock(false)
                
                switch result {
                case .success(let accessInfo):
                    self.authMan.onSignin(accessInfo: accessInfo)
                case .failure(let apiError):
                    print(apiError.localizedDescription)
                    self.errorMessage = apiError.message
                }
            }
        }
    }
}

extension SigninViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let codeData = credential.authorizationCode,
              let authCode = String(data: codeData, encoding: .utf8)
        else {
            return
        }
        
        signinApple(authCode: authCode)
    }
}
