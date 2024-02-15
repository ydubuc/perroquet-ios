//
//  AuthService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation

class AuthService {
    let url: URL
    
    init(backendUrl: String) {
        self.url = URL(string: backendUrl.appending("/auth"))!
        print(url.absoluteString)
    }
    
    func signin(dto: SigninDto) async -> Result<AccessInfo, ApiError> {
        var request = URLRequest(url: url.appending(path: "/signin"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let payload = try encoder.encode(dto)
            request.httpBody = payload
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let apiError = try decoder.decode(ApiError.self, from: data)
                throw apiError
            }
            
            let accessInfo = try decoder.decode(AccessInfo.self, from: data)
            return .success(accessInfo)
        } catch let e as ApiError {
            return .failure(e)
        } catch let e {
            return .failure(ApiError(code: 500, message: "An error occurred."))
        }
    }
    
    func signinApple(dto: SigninAppleDto) async -> Result<AccessInfo, ApiError> {
        var request = URLRequest(url: url.appending(path: "/signin/apple"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request.url)
        
        do {
            let encoder = JSONEncoder()
            let payload = try encoder.encode(dto)
            request.httpBody = payload
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let apiError = try decoder.decode(ApiError.self, from: data)
                throw apiError
            }
            
            print(httpResponse.statusCode)
            
            let accessInfo = try decoder.decode(AccessInfo.self, from: data)
            return .success(accessInfo)
        } catch let e as ApiError {
            return .failure(e)
        } catch let e {
            print(e.localizedDescription)
            return .failure(ApiError(code: 500, message: "An error occurred."))
        }
    }
}
