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
    let remindersService: RemindersService
    
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var frequency: String = ""
    @Published var visibility: Int = 0
    @Published var triggerAtDate: Date = Date.now
    
    init(
        appVm: AppViewModel = AppViewModel.shared,
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL)
    ) {
        self.appVm = appVm
        self.authMan = authMan
        self.notificator = notificator
        self.remindersService = remindersService
    }
    
    func createReminder() {
        Task {
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds
            let dto = CreateReminderDto(title: nil, body: body, frequency: nil, visibility: visibility, triggerAt: triggerAt)
            
            let tempId = UUID().uuidString
            await scheduleLocalNotification(id: tempId, triggerAt: triggerAt)
            
            guard let accessToken = await authMan.accessToken() else { return }
            let result = await remindersService.createReminder(dto: dto, accessToken: accessToken)
            
            switch result {
            case .success(let reminder):
                self.notificator.delete(ids: [tempId])
                await notificator.schedule(notification: reminder.toLocalNotification())
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
    
    func scheduleLocalNotification(id: String, triggerAt: Int) async {
        let currentTime = Date().timeIntervalSince1970.milliseconds
        let localReminder = Reminder(
            id: id,
            userId: authMan.accessTokenClaims?.id ?? "",
            title: title.isEmpty ? nil : title,
            body: body,
            frequency: frequency.isEmpty ? nil : frequency,
            visibility: visibility,
            triggerAt: triggerAt,
            updatedAt: currentTime,
            createdAt: currentTime
        )
        await notificator.schedule(notification: localReminder.toLocalNotification())
    }
}
