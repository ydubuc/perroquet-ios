//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published private(set) var theme: Theme
    
    private var accessInfo: AccessInfo?
    private var accessTokenClaims: AccessTokenClaims?
    @Published private(set) var isLoggedIn: Bool
    
    let authService: AuthService
    
    init() {
        self.theme = DarkTheme()
        
        self.accessInfo = nil
        self.accessTokenClaims = nil
        self.isLoggedIn = false
        
        self.authService = AuthService(url: Config.BACKEND_URL)
    }
    
    func setTheme(theme: Theme) {
        self.theme = theme
    }

    func onSignin(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            // cache
            print(accessInfo)
            print(accessTokenClaims)
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.isLoggedIn = true
        case .failure(let appError):
            print(appError)
        }
    }
    
    private func onRefresh(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            // cache
            print(accessInfo)
            print(accessTokenClaims)
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.isLoggedIn = true
        case .failure(let appError):
            print(appError)
        }
    }

    func onSignout() {
        // delete cache
        self.accessInfo = nil
        self.accessTokenClaims = nil
        self.isLoggedIn = false
    }
    
    func accessToken() async -> String? {
        guard let accessInfo = accessInfo,
              let claims = accessTokenClaims
        else {
            return nil
        }
        
        guard (claims.exp - Date().timeIntervalSince1970) <= 0 else {
            return accessInfo.accessToken
        }
        
        let dto = RefreshAccessInfoDto(refreshToken: accessInfo.refreshToken)
        let result = await authService.refresh(dto: dto)
        
        switch result {
        case .success(let refreshedAccessInfo):
            onRefresh(accessInfo: refreshedAccessInfo)
            return refreshedAccessInfo.accessToken
        case .failure(let apiError):
            print(apiError)
            return nil
        }
    }
}
