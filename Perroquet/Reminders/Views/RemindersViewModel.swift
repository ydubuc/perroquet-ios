//
//  RemindersViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class RemindersViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    let notificator: Notificator
    let remindersService: RemindersService
    
    @Published var reminders: [Reminder] = []
    
    @Published var userId: String?
    @Published var search: String?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?
    
    @Published var errorMessage: String = ""
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        dto: GetRemindersFilterDto
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.notificator = notificator
        self.remindersService = remindersService
        
        self.userId = dto.userId
        self.search = dto.search
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
        
        self.afterInit()
    }
    
    func afterInit() {
        Task { await self.load() }
    }
    
    func load() async {
        guard let accessToken = await authMan.accessToken() else { return }
        
        let dto = GetRemindersFilterDto(id: nil, userId: userId, search: search, sort: sort, cursor: cursor, limit: limit)
        let result = await remindersService.getReminders(dto: dto, accessToken: accessToken)
        
        DispatchQueue.main.async {
            switch result {
            case .success(let reminders):
                self.reminders = reminders
                print(reminders)
                self.scheduleReminders()
            case .failure(let apiError):
                print(apiError.localizedDescription)
                self.errorMessage = apiError.message
            }
        }
    }
    
    private func scheduleReminders() {
        Task {
            for reminder in reminders {
                await notificator.schedule(notification: reminder.toLocalNotification())
            }
        }
    }
    
}
