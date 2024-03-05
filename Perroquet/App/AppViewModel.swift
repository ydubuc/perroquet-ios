//
//  AppViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/11/24.
//

import Foundation
import SwiftUI
import SimpleKeychain

class AppViewModel: ObservableObject {
    let notificator: Notificator
    let remindersService: RemindersService

    @Published var theme: Theme

    @Published var isPresentingCreateReminderView = false

    private var lastAppRefresh = Date().timeIntervalSince1970.milliseconds

    init(
        notificator: Notificator = Notificator(),
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL)
    ) {
        self.notificator = notificator
        self.remindersService = remindersService

        self.theme = DarkTheme()
    }

    func refreshApp(authMan: AuthMan) async {
        guard let accessToken = await authMan.accessToken() else { return }

        let result = await remindersService.getReminders(
            dto: .init(
                id: nil,
                userId: authMan.accessTokenClaims?.id,
                search: nil,
                tags: nil,
                visibility: nil,
                sort: "updated_at,asc",
                cursor: "\(lastAppRefresh),\(UUID().uuidString.lowercased())",
                limit: nil
            ),
            accessToken: accessToken
        )

        self.lastAppRefresh = Date().timeIntervalSince1970.milliseconds

        switch result {
        case .success(let reminders):
            scheduleReminders(reminders: reminders)
        case .failure(let apiError):
            print(apiError.message)
            return
        }
    }

    func scheduleReminders(reminders: [Reminder]?) {
        let reminders = reminders ?? Stash.shared.getReminders() ?? []

        Task {
            for reminder in reminders {
                await notificator.schedule(notification: reminder.toLocalNotification())
            }
        }
    }
}
