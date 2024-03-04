//
//  DiscoverViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class DiscoverViewModel: ObservableObject, ReminderListener {
    let authMan: AuthMan
    let notificator: Notificator
    let remindersService: RemindersService
    
    @Published var reminders: [Reminder] = []
    
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
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        dto: GetRemindersFilterDto
    ) {
        self.authMan = authMan
        self.notificator = notificator
        self.remindersService = remindersService
        
        self.userId = dto.userId
        self.search = dto.search
        self.tags = dto.tags
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
        
        self.afterInit()
    }
    
    private func afterInit() {
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
        array.append(contentsOf: newReminders)
        
        self.reminders = array.sorted { $0.triggerAt > $1.triggerAt }
    }
    
    func onCreateReminder(_ reminder: Reminder) {
        print("on create")
    }
    
    func onEditReminder(_ reminder: Reminder) {
        print("on edit")
    }
    
    func onDeleteReminder(_ reminder: Reminder) {
        print("on delete")
    }
}
