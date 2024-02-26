//
//  AuthMan.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import Foundation
import SimpleKeychain

class AuthMan: ObservableObject {
    static let shared = AuthMan()
    
    private let authService: AuthService
    private let devicesService: DevicesService
    private let notificator: Notificator
    private let simpleKeychain = SimpleKeychain()
    
    var accessInfo: AccessInfo? = nil
    var accessTokenClaims: AccessTokenClaims? = nil
    @Published var isLoggedIn: Bool = false
    
    private var isRefreshing = false
    
    private init(
        authService: AuthService = AuthService(url: Config.BACKEND_URL),
        devicesService: DevicesService = DevicesService(url: Config.BACKEND_URL),
        notificator: Notificator = Notificator()
    ) {
        self.authService = authService
        self.devicesService = devicesService
        self.notificator = notificator
        
        if let accessInfo = getCachedAccessInfo() {
            onSignin(accessInfo: accessInfo)
        }
    }
    
    func onSignin(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            print("onSignin success")
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.isLoggedIn = true
            self.cacheAccessInfo(accessInfo: accessInfo)
            
            if let messagingToken = getCachedMessagingToken() {
                self.onNewMessagingToken(messagingToken: messagingToken)
            }
        case .failure(let appError):
            print("onSignin failure")
            print(appError)
        }
    }
    
    private func onRefresh(accessInfo: AccessInfo) {
        let accessTokenClaimsResult: Result<AccessTokenClaims, AppError> = JwtDecoder.decode(jwt: accessInfo.accessToken)
        
        switch accessTokenClaimsResult {
        case .success(let accessTokenClaims):
            print("onRefresh success")
            self.accessInfo = accessInfo
            self.accessTokenClaims = accessTokenClaims
            self.cacheAccessInfo(accessInfo: accessInfo)
        case .failure(let appError):
            print("onRefresh failure")
            print(appError.localizedDescription)
        }
    }

    func onSignout() {
        print("onSignout")
        
        // send delete device request
        
        self.notificator.clearAllNotifications()
        self.notificator.deleteAll()
        self.deleteCachedMessagingToken()
        self.deleteCachedAccessInfo()
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
        
        guard (claims.exp - Date().timeIntervalSince1970.seconds) <= 0 else {
            print("accessToken not expired")
            return accessInfo.accessToken
        }
        
        if isRefreshing {
            do {
                try await Task.sleep(nanoseconds: 1 * 1000000000)
                return await accessToken()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            isRefreshing = true
        }
        
        print("refreshing accessToken")
        let dto = RefreshAccessInfoDto(refreshToken: accessInfo.refreshToken)
        let result = await authService.refresh(dto: dto)
        
        switch result {
        case .success(let refreshedAccessInfo):
            DispatchQueue.main.async {
                if self.isLoggedIn {
                    self.onRefresh(accessInfo: refreshedAccessInfo)
                }
                self.isRefreshing = false
            }
            return refreshedAccessInfo.accessToken
        case .failure(let apiError):
            print(apiError.message)
            self.isRefreshing = false
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

extension AuthMan {
    func onNewMessagingToken(messagingToken: String) {
        cacheMessagingToken(messagingToken: messagingToken)
        
        guard let accessInfo = accessInfo else { return }
        
        Task {
            let dto = EditDeviceDto(messagingToken: messagingToken)
            let _ = await devicesService.editDevice(id: accessInfo.deviceId, dto: dto, accessToken: accessInfo.accessToken)
        }
    }
    
    func cacheMessagingToken(messagingToken: String) {
        do {
            try simpleKeychain.set(messagingToken, forKey: "messaging_token")
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func getCachedMessagingToken() -> String? {
        do {
            let messagingToken = try simpleKeychain.string(forKey: "messaging_token")
            
            return messagingToken
        } catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
    
    func deleteCachedMessagingToken() {
        do {
            try simpleKeychain.deleteItem(forKey: "messaging_token")
        } catch let e {
            print(e.localizedDescription)
        }
    }
}
