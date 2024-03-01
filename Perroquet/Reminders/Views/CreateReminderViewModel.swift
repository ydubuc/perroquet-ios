//
//  CreateReminderViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import Foundation

class CreateReminderViewModel: ObservableObject {
    let appVm: AppViewModel
    let authMan: AuthMan
    let notificator: Notificator
    let stash: Stash
    let remindersService: RemindersService
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
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
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.notificator = notificator
        self.stash = stash
        self.remindersService = remindersService
    }
    
    func createReminder() {
        Task {
            let tempId = "temp-\(UUID().uuidString)"
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds
            let tempReminder = Reminder(
                id: tempId,
                userId: authMan.accessTokenClaims?.id ?? "",
                title: title,
                description: description.isEmpty ? nil : description,
                tags: tags.isEmpty ? nil : tags,
                frequency: frequency.isEmpty ? nil : frequency,
                visibility: visibility,
                triggerAt: triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: currentTimeInMillis
            )
            
            stash.insertReminder(reminder: tempReminder)
            await notificator.schedule(notification: tempReminder.toLocalNotification())
            
            let dto = CreateReminderDto(
                title: title,
                description: description.isEmpty ? nil : description,
                tags: tags.isEmpty ? nil : tags,
                frequency: frequency.isEmpty ? nil : frequency,
                visibility: visibility,
                triggerAt: triggerAt
            )
            
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.createReminder(dto: dto, accessToken: accessToken)
            
            switch result {
            case .success(let reminder):
                stash.deleteReminder(id: tempId)
                self.notificator.delete(ids: [tempId])
                await notificator.schedule(notification: reminder.toLocalNotification())
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
