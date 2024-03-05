//
//  SigninDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

struct SigninDto: Codable {
    let email: String
    let passw: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case passw = "password"
    }
}
