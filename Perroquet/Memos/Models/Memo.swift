//
//  Memo.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct Memo: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let title: String
    let description: String?
    let priority: String?
    let status: String
    let visibility: Int
    let frequency: String?
    let triggerAt: Int
    let updatedAt: Int
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case description = "description"
        case priority = "priority"
        case status = "status"
        case visibility = "visibility"
        case frequency = "frequency"
        case triggerAt = "trigger_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }

    func toLocalNotification() -> LocalNotification {
        return LocalNotification(
            id: self.id,
            title: self.description == nil ? "Perroquet says:" : self.title,
            description: self.description == nil ? self.title : self.description!,
            frequency: self.frequency,
            triggerAt: self.triggerAt
        )
    }

    static func randomPlaceholder() -> String {
        return [
            "drink more water",
            "do laundry in 2 hours",
            "mow the lawn this afternoon",
            "redeem points tomorrow",
            "rate Perroquet",
            "feed parrot",
            "thaw food by noon",
            "water plants in 15 minutes",
            "take out the trash tonight",
            "replace filter at 2:30 pm",
            "clean room on thursday"
        ].randomElement()!
    }
}
