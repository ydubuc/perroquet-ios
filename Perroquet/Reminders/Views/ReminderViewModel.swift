//
//  ReminderViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

class ReminderViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    let notificator: Notificator
    let stash: Stash
    let remindersService: RemindersService
    
    let reminder: Reminder
    
    @Published var title: String
    @Published var description: String
    @Published var tags: [String]
    @Published var frequency: String
    @Published var visibility: Int
    @Published var triggerAtDate: Date
    
    @Published var placeholder = Reminder.randomPlaceholder()
    
    @Published var isPresentingReminderActionsView = false
    @Published var isPresentingDatePickerView = false
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        stash: Stash = Stash.shared,
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        reminder: Reminder
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.notificator = notificator
        self.stash = stash
        self.remindersService = remindersService
        
        self.reminder = reminder
        
        self.title = reminder.title
        self.description = reminder.description ?? ""
        self.tags = reminder.tags ?? []
        self.frequency = reminder.frequency ?? ""
        self.visibility = reminder.visibility
        self.triggerAtDate = Date(timeIntervalSince1970: TimeInterval(reminder.triggerAt / 1000))
    }
    
    func editReminder() {
        Task {
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds
            let tempReminder = Reminder(
                id: reminder.id,
                userId: reminder.userId,
                title: title,
                description: description.isEmpty ? nil : description,
                tags: tags.isEmpty ? nil : tags,
                frequency: frequency.isEmpty ? nil : frequency,
                visibility: visibility,
                triggerAt: triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: reminder.createdAt
            )
            
            stash.insertReminder(reminder: tempReminder)
            await notificator.schedule(notification: tempReminder.toLocalNotification())
            
            let dto = EditReminderDto(
                title: title,
                description: description.isEmpty ? nil : description,
                tags: tags.isEmpty ? nil : tags,
                frequency: frequency.isEmpty ? nil : frequency,
                visibility: visibility,
                triggerAt: triggerAt
            )
            
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.editReminder(id: reminder.id, dto: dto, accessToken: accessToken)
            
            switch result {
            case .success(_):
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
    
    func deleteReminder() {
        Task {
            stash.deleteReminder(id: reminder.id)
            notificator.delete(ids: [reminder.id])
            
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.deleteReminder(id: reminder.id, accessToken: accessToken)
            
            switch result {
            case .success(_):
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
