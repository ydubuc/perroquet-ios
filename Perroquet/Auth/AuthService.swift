//
//  AuthService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation

class AuthService {
    let url: String
    let courier = Courier()
    
    init(url: String) {
        self.url = url.appending("/auth")
    }
    
    func signin(dto: SigninDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/signin")) else {
            return .failure(ApiError.invalidUrl())
        }

        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourrierError(courierError))
        }
    }
    
    func signinApple(dto: SigninAppleDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/signin/apple")) else {
            return .failure(ApiError.invalidUrl())
        }
        
        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourrierError(courierError))
        }
    }
}
