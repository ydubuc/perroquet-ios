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
    
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var frequency: String = ""
    @Published var visibility: Int = 0
    @Published var triggerAtDate: Date = Date.now
    
    @Published var placeholder = Reminder.randomPlaceholder()
    
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
        
        self.title = reminder.title ?? ""
        self.body = reminder.body
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
                title: title.isEmpty ? nil : title,
                body: body,
                frequency: frequency.isEmpty ? nil : frequency,
                visibility: visibility,
                triggerAt: triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: reminder.createdAt
            )
            
            stash.cacheReminder(reminder: tempReminder)
            await notificator.schedule(notification: tempReminder.toLocalNotification())
            
            let dto = EditReminderDto(
                title: title.isEmpty ? nil : title,
                body: body,
                frequency: frequency,
                visibility: visibility,
                triggerAt: triggerAt
            )
            
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.editReminder(id: reminder.id, dto: dto, accessToken: accessToken)
            
            switch result {
            case .success(let reminder):
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
