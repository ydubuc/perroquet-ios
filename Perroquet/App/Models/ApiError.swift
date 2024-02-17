//
//  ApiError.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

class ApiError: Error, Codable {
    let code: Int
    let message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

extension ApiError {
    static func invalidUrl() -> ApiError {
        return ApiError(code: -1, message: "Invalid URL.")
    }
    
    static func fromCourierError(_ courierError: CourierError) -> ApiError {
        guard let (data, response) = courierError.data else {
            return ApiError(code: courierError.code, message: courierError.message)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let apiError = try decoder.decode(ApiError.self, from: data)
            return apiError
        } catch let e {
            return ApiError(code: courierError.code, message: courierError.message)
        }
    }
}
