//
//  AppError.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct AppError: Equatable {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? { return message }
}
