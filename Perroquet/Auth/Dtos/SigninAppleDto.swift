//
//  SigninAppleDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

struct SigninAppleDto: Codable {
    let authCode: String
    
    enum CodingKeys: String, CodingKey {
        case authCode = "auth_code"
    }
}
