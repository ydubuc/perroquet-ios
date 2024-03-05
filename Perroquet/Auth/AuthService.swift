//
//  AuthService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation

class AuthService {
    private let url: String
    private let courier = Courier()

    init(url: String) {
        self.url = url.appending("/auth")
    }

    func signup(dto: SignupDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/signup")) else {
            return .failure(ApiError.invalidUrl())
        }

        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, headers: [:], body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func signin(dto: SigninDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/signin")) else {
            return .failure(ApiError.invalidUrl())
        }

        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, headers: [:], body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func signinApple(dto: SigninAppleDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/signin/apple")) else {
            return .failure(ApiError.invalidUrl())
        }

        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, headers: [:], body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func refresh(dto: RefreshAccessInfoDto) async -> Result<AccessInfo, ApiError> {
        guard let url = URL(string: url.appending("/refresh")) else {
            return .failure(ApiError.invalidUrl())
        }

        let result: Result<AccessInfo, CourierError> = await courier.post(url: url, headers: [:], body: dto)
        switch result {
        case .success(let accessInfo):
            return .success(accessInfo)
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }

    func signout(dto: SignoutDto, accessToken: String) async -> Result<(), ApiError> {
        guard let url = URL(string: url.appending("/signout")) else {
            return .failure(ApiError.invalidUrl())
        }

        let headers = ["Authorization": accessToken]
        let result: Result<Nothing, CourierError> = await courier.post(url: url, headers: headers, body: dto)
        switch result {
        case.success:
            return .success(())
        case .failure(let courierError):
            return .failure(ApiError.fromCourierError(courierError))
        }
    }
}
