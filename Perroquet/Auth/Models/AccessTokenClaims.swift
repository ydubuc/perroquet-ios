//
//  AccessTokenClaims.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct AccessTokenClaims: Codable {
    let id: String
    let iat: TimeInterval
    let exp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case iat = "iat"
        case exp = "exp"
    }
}
