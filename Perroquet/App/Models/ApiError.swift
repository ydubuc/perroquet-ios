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
