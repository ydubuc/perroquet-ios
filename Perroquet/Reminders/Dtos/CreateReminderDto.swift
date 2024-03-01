//
//  CreateReminderDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

struct CreateReminderDto: Codable {
    let title: String
    let description: String?
    let tags: [String]?
    let frequency: String?
    let visibility: Int
    let triggerAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case tags = "tags"
        case frequency = "frequency"
        case visibility = "visibility"
        case triggerAt = "trigger_at"
    }
}
