//
//  SignupDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct SignupDto: Codable {
    let email: String
    let passw: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case passw = "password"
    }
}
