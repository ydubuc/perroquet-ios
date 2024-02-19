//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation
import SwiftUI
import SimpleKeychain

class AppViewModel: ObservableObject {
    @Published private(set) var theme: Theme

    private let simpleKeychain = SimpleKeychain()
    private(set) var accessInfo: AccessInfo?
    private(set) var accessTokenClaims: AccessTokenClaims?
    @Published private(set) var isLoggedIn: Bool
    
    let authService: AuthService
    
    init() {
        self.theme = DarkTheme()
        
        self.accessInfo = nil
        self.accessTokenClaims = nil
        self.isLoggedIn = false
        
        self.authService = AuthService(url: Config.BACKEND_URL)
        
        if let accessInfo = getCachedAccessInfo() {
            onSignin(accessInfo: accessInfo)
        }
    }
    
    func setTheme(theme: Theme) {
        self.theme = theme
    }

    func onSignin(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.isLoggedIn = true
            self.cacheAccessInfo(accessInfo: accessInfo)
        case .failure(let appError):
            print(appError)
        }
    }
    
    private func onRefresh(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.isLoggedIn = true
            self.cacheAccessInfo(accessInfo: accessInfo)
        case .failure(let appError):
            print(appError.localizedDescription)
        }
    }

    func onSignout() {
        self.accessInfo = nil
        self.accessTokenClaims = nil
        self.isLoggedIn = false
        self.deleteCachedAccessInfo()
    }
    
    func accessToken() async -> String? {
        guard let accessInfo = accessInfo,
              let claims = accessTokenClaims
        else {
            return nil
        }
        
        guard (claims.exp - Date().timeIntervalSince1970.milliseconds) <= 0 else {
            return accessInfo.accessToken
        }
        
        let dto = RefreshAccessInfoDto(refreshToken: accessInfo.refreshToken)
        let result = await authService.refresh(dto: dto)
        
        switch result {
        case .success(let refreshedAccessInfo):
            onRefresh(accessInfo: refreshedAccessInfo)
            return refreshedAccessInfo.accessToken
        case .failure(let apiError):
            print(apiError.localizedDescription)
            return nil
        }
    }
    
    private func cacheAccessInfo(accessInfo: AccessInfo) {
        do {
            try simpleKeychain.set(accessInfo.accessToken, forKey: "access_token")
            try simpleKeychain.set(accessInfo.refreshToken, forKey: "refresh_token")
            try simpleKeychain.set(accessInfo.deviceId, forKey: "device_id")
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    private func getCachedAccessInfo() -> AccessInfo? {
        do {
            let accessToken = try simpleKeychain.string(forKey: "access_token")
            let refreshToken = try simpleKeychain.string(forKey: "refresh_token")
            let deviceId = try simpleKeychain.string(forKey: "device_id")
            
            return AccessInfo(accessToken: accessToken, refreshToken: refreshToken, deviceId: deviceId)
        } catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
    
    private func deleteCachedAccessInfo() {
        do {
            try simpleKeychain.deleteItem(forKey: "access_token")
            try simpleKeychain.deleteItem(forKey: "refresh_token")
            try simpleKeychain.deleteItem(forKey: "device_id")
        } catch let e {
            print(e.localizedDescription)
        }
    }
}
