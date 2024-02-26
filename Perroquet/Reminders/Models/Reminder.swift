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
    let body: String
    let frequency: String?
    let visibility: Int
    let triggerAt: Int
    let updatedAt: Int
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case body = "body"
        case frequency = "frequency"
        case visibility = "visibility"
        case triggerAt = "trigger_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
    
    func toLocalNotification() -> LocalNotification {
        return LocalNotification(
            id: self.id,
            title: self.title ?? "Perroquet",
            body: self.body,
            triggerAt: self.triggerAt
        )
    }
}
