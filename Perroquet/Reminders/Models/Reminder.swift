//
//  Reminder.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct Reminder: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String?
    let content: String
    let frequency: String?
    let triggerAt: Int
    let updatedAt: Int
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case content = "content"
        case frequency = "frequency"
        case triggerAt = "trigger_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
