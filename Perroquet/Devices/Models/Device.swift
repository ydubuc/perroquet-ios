//
//  Device.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation

struct Device: Codable {
    let id: String
    let userId: String
    let refreshedAt: Int
    let updatedAt: Int
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case refreshedAt = "refreshed_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
