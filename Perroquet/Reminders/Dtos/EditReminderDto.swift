//
//  EditReminderDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

struct EditReminderDto: Codable {
    let title: String?
    let body: String?
    let frequency: String?
    let triggerAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
        case frequency = "frequency"
        case triggerAt = "trigger_at"
    }
}
