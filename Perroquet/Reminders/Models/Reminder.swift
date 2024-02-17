//
//  Reminder.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct Reminder: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}
