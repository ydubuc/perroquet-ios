//
//  RemindersService.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

class RemindersService {
    let url: String
    let courier = Courier()
    
    init(url: String) {
        self.url = url.appending("/reminders")
    }
    
//    func getReminders() async -> Result<[Reminder], ApiError> {
//        
//    }
}
