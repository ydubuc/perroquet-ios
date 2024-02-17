//
//  AccessInfo.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation

struct AccessInfo: Codable {
    let accessToken: String
    let refreshToken: String
    let deviceId: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case deviceId = "device_id"
    }
}
