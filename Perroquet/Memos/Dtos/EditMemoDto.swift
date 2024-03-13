//
//  EditMemoDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

struct EditMemoDto: Codable {
    let title: String?
    let description: String?
    let priority: String?
    let status: String?
    let visibility: Int?
    let frequency: String?
    let triggerAt: Int?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case priority = "priority"
        case status = "status"
        case visibility = "visibility"
        case frequency = "frequency"
        case triggerAt = "trigger_at"
    }
}
