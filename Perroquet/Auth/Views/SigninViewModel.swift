//
//  SigninViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import AuthenticationServices

class SigninViewModel: NSObject, ObservableObject {
    @Published var appVm: AppViewModel
    @Published var email: String = ""
    @Published var passw: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    let authService: AuthService
    
    init(
        appVm: AppViewModel,
        authService: AuthService = AuthService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        self.authService = authService
    }
    
    func lock(_ state: Bool) {
        switch state {
        case true:
            isLoading = true
            errorMessage = ""
        case false:
            isLoading = false
        }
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
                    self.appVm.onSignin(accessInfo: accessInfo)
                case .failure(let apiError):
                    print(apiError)
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
                    self.appVm.onSignin(accessInfo: accessInfo)
                case .failure(let apiError):
                    print(apiError.message)
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
