//
//  AuthViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    let authService: AuthService
    
    @Published var email: String = ""
    @Published var passw: String = ""
    
    init(
        authService: AuthService = AuthService(backendUrl: Config.BACKEND_URL)
    ) {
        self.authService = authService
    }
    
    func signin() {
        let email = email
        let passw = passw
        
        let dto = SigninDto(email: email, passw: passw)
        
        Task {
            let result = await authService.signin(dto: dto)
            switch result {
            case .success(let accessToken):
                print(accessToken)
            case .failure(let apiError):
                print(apiError)
            }
        }
    }
    
    func signinApple(authCode: String) {
        let dto = SigninAppleDto(authCode: authCode)
        
        Task {
            let result = await authService.signinApple(dto: dto)
            switch result {
            case .success(let accessToken):
                print(accessToken)
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
