//
//  CreateReminderViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import Foundation

class CreateReminderViewModel: ObservableObject {
    let authMan: AuthMan
    let notificator: Notificator
    let stash: Stash
    let remindersService: RemindersService

    var listener: ReminderListener?

    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var frequency: String = ""
    @Published var visibility: Int = 0
    @Published var triggerAtDate: Date = Date.now

    @Published var placeholder = Reminder.randomPlaceholder()

    @Published var isPresentingDatePickerView = false

    init(
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        stash: Stash = Stash.shared,
        remindersService: RemindersService = RemindersService(url: Config.BACKEND_URL),
        listener: ReminderListener?
    ) {
        self.authMan = authMan
        self.notificator = notificator
        self.stash = stash
        self.remindersService = remindersService

        self.listener = listener
    }

    func createReminder() {
        Task {
            let id = "\(UUID().uuidString.lowercased())"
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds

            let reminder = Reminder(
                id: id,
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

            stash.insertReminder(reminder: reminder)
            await notificator.schedule(notification: reminder.toLocalNotification())

            DispatchQueue.main.async { [weak self] in
                self?.listener?.onCreateReminder(reminder)
            }

            let dto = CreateReminderDto(
                id: id,
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
            case .success:
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
