//
//  RemindersViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class RemindersViewModel: ObservableObject, ReminderListener {
    let authMan: AuthMan
    let stash: Stash
    let notificator: Notificator
    let remindersService: RemindersService
    
    @Published var reminders: [Reminder]
    @Published var todayReminders: [Reminder]
    @Published var sevenDaysReminders: [Reminder]
    @Published var laterReminders: [Reminder]
    @Published var previousReminders: [Reminder]
    
    @Published var userId: String?
    @Published var search: String?
    @Published var tags: String?
    @Published var visibility: Int?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?
    
    @Published var errorMessage: String = ""
    
    init(
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared,
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        reminders: [Reminder]? = nil,
        dto: GetRemindersFilterDto = .init()
    ) {
        self.authMan = authMan
        self.stash = stash
        self.notificator = notificator
        self.remindersService = remindersService
        
        let reminders = reminders ?? []
        self.reminders = reminders.isEmpty ? reminders : reminders.sorted { $0.updatedAt > $1.updatedAt }
        
        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()
        
        self.todayReminders = reminders
            .filter { $0.triggerAt > currentTimestamp && $0.triggerAt < endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.sevenDaysReminders = reminders
            .filter { $0.triggerAt > endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.laterReminders = reminders
            .filter { $0.triggerAt > sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.previousReminders = reminders
            .filter { $0.triggerAt < currentTimestamp }
            .sorted { $0.triggerAt > $1.triggerAt }
        
        self.userId = dto.userId
        self.search = dto.search
        self.tags = dto.tags
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
        
        self.afterInit()
    }
    
    func afterInit() {
        if !reminders.isEmpty {
            self.sort = "updated_at,asc"
        }
        
        Task { await self.load() }
    }
    
    func load() async {
        guard let accessToken = await authMan.accessToken() else { return }
        
        let dto = GetRemindersFilterDto(
            id: nil,
            userId: userId,
            search: search,
            tags: tags,
            visibility: visibility,
            sort: sort,
            cursor: getCursor(sort: sort),
            limit: limit
        )
        
        let result = await remindersService.getReminders(dto: dto, accessToken: accessToken)
        
        switch result {
        case .success(let reminders):
            DispatchQueue.main.async {
                self.insertAndOrderReminders(newReminders: reminders)
                self.scheduleReminders()
            }
        case .failure(let apiError):
            DispatchQueue.main.async {
                print(apiError.localizedDescription)
                self.errorMessage = apiError.message
            }
        }
    }
    
    private func getCursor(sort: String?) -> String? {
        guard !reminders.isEmpty else { return cursor }

        switch sort {
        case "trigger_at,asc":
            return "\(reminders.first!.triggerAt),\(reminders.first!.id)"
        case "trigger_at,desc":
            return "\(reminders.last!.triggerAt),\(reminders.last!.id)"
        case "updated_at,asc":
            return "\(reminders.first!.updatedAt),\(reminders.first!.id)"
        case "updated_at,desc":
            return "\(reminders.last!.updatedAt),\(reminders.last!.id)"
        case "created_at,asc":
            return "\(reminders.first!.createdAt),\(reminders.first!.id)"
        case "created_at,desc":
            return "\(reminders.last!.createdAt),\(reminders.last!.id)"
        default:
            fatalError("Sort not implemented.")
        }
    }
    
    func insertAndOrderReminders(newReminders: [Reminder]) {
        let idSet = Set(newReminders.map { $0.id })
        
        var array = self.reminders.filter { !idSet.contains($0.id) }
        
        if sort?.hasSuffix("asc") == true {
            array.insert(contentsOf: newReminders, at: 0)
        } else {
            array.append(contentsOf: newReminders)
        }
        
        self.reminders = array
        
        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()
        
        self.todayReminders = self.reminders
            .filter { $0.triggerAt > currentTimestamp && $0.triggerAt < endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.sevenDaysReminders = self.reminders
            .filter { $0.triggerAt > endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.laterReminders = self.reminders
            .filter { $0.triggerAt > sevenDaysTimestamp }
            .sorted { $0.triggerAt < $1.triggerAt }
        self.previousReminders = self.reminders
            .filter { $0.triggerAt < currentTimestamp }
            .sorted { $0.triggerAt > $1.triggerAt }
    }

    private func scheduleReminders() {
        Task {
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let reminders = reminders.filter { reminder in
                reminder.triggerAt > currentTimeInMillis || reminder.frequency != nil
            }
            for reminder in reminders {
                await notificator.schedule(notification: reminder.toLocalNotification())
            }
        }
    }
    
    func onCreateReminder(_ reminder: Reminder) {
        insertAndOrderReminders(newReminders: [reminder])
    }
    
    func onEditReminder(_ reminder: Reminder) {
        insertAndOrderReminders(newReminders: [reminder])
    }
    
    func onDeleteReminder(_ reminder: Reminder) {
        self.reminders = self.reminders.filter { $0.id != reminder.id }
        self.todayReminders = self.todayReminders.filter { $0.id != reminder.id }
        self.sevenDaysReminders = self.sevenDaysReminders.filter { $0.id != reminder.id }
        self.laterReminders = self.laterReminders.filter { $0.id != reminder.id }
        self.previousReminders = self.previousReminders.filter { $0.id != reminder.id }
    }
}
