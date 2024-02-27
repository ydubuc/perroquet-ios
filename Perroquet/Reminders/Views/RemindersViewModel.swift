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
    let stash: Stash
    let notificator: Notificator
    let remindersService: RemindersService
    
    @Published var reminders: [Reminder] = []
    
    @Published var userId: String?
    @Published var search: String?
    @Published var visibility: Int?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?
    
    @Published var errorMessage: String = ""
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared,
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        dto: GetRemindersFilterDto
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.stash = stash
        self.notificator = notificator
        self.remindersService = remindersService
        
        self.userId = dto.userId
        self.search = dto.search
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
        
        self.afterInit()
    }
    
    func afterInit() {
        if let reminders = stash.getReminders() {
            self.reminders = reminders.sorted { $0.triggerAt > $1.triggerAt }
            self.sort = "updated_at,asc"
            self.cursor = "\(reminders.first!.updatedAt),\(reminders.first!.id)"
        }
        
        Task { await self.load() }
    }
    
    func load() async {
        guard let accessToken = await authMan.accessToken() else { return }
        
        let dto = GetRemindersFilterDto(
            id: nil,
            userId: userId,
            search: search,
            visibility: visibility,
            sort: sort,
            cursor: cursor,
            limit: limit
        )
        
        let result = await remindersService.getReminders(dto: dto, accessToken: accessToken)
        
        switch result {
        case .success(let reminders):
            let orderedReminders = insertAndOrderNewReminders(newReminders: reminders)
            
            DispatchQueue.main.async {
                self.reminders = orderedReminders
                self.scheduleReminders()
            }
        case .failure(let apiError):
            DispatchQueue.main.async {
                print(apiError.localizedDescription)
                self.errorMessage = apiError.message
            }
        }
    }
    
    private func insertAndOrderNewReminders(newReminders: [Reminder]) -> [Reminder] {
        var idSet = Set<String>(newReminders.map { $0.id })
        
        var array = self.reminders.filter { !idSet.contains($0.id) }
        array.append(contentsOf: newReminders)
        
        return array.sorted { $0.triggerAt > $1.triggerAt }
    }
    
    private func scheduleReminders() {
        Task {
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let reminders = reminders.filter { reminder in
                reminder.triggerAt > currentTimeInMillis
            }
            for reminder in reminders {
                await notificator.schedule(notification: reminder.toLocalNotification())
            }
        }
    }
}
