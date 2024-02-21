//
//  EditDeviceDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation

struct EditDeviceDto: Codable {
    let messagingToken: String?
    
    enum CodingKeys: String, CodingKey {
        case messagingToken = "messaging_token"
    }
}
