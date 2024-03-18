//
//  CreateMemoViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import Foundation

class CreateMemoViewModel: ObservableObject {
    let authMan: AuthMan
    let notificator: Notificator
    let stash: Stash
    let memosService: MemosService

    var listener: MemoListener?

    @Published var title: String = ""
    @Published var description: String = ""
    @Published var priority: String = ""
    @Published var visibility: Int = Memo.Visibility.priv.rawValue
    @Published var frequency: String = ""
    @Published var triggerAtDate: Date = Date.now

    @Published var placeholder = Memo.randomPlaceholder()

    @Published var isPresentingDatePickerView = false

    init(
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        stash: Stash = Stash.shared,
        memosService: MemosService = MemosService(url: Config.BACKEND_URL),
        listener: MemoListener?
    ) {
        self.authMan = authMan
        self.notificator = notificator
        self.stash = stash
        self.memosService = memosService

        self.listener = listener
    }

    func createMemo() {
        Task {
            let id = "\(UUID().uuidString.lowercased())"
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds

            let memo = Memo(
                id: id,
                userId: authMan.accessTokenClaims?.id ?? "",
                title: title,
                description: description.isEmpty ? nil : description,
                priority: priority.isEmpty ? nil : priority,
                status: Memo.Status.pending.rawValue,
                visibility: visibility,
                frequency: frequency.isEmpty ? nil : frequency,
                triggerAt: triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: currentTimeInMillis
            )

            stash.insertMemo(memo: memo)
            await notificator.schedule(notification: memo.toLocalNotification())

            DispatchQueue.main.async { [weak self] in
                self?.listener?.onCreateMemo(memo)
            }

            let dto = CreateMemoDto(
                id: id,
                title: title,
                description: description.isEmpty ? nil : description,
                priority: priority.isEmpty ? nil : priority,
                visibility: visibility,
                frequency: frequency.isEmpty ? nil : frequency,
                triggerAt: triggerAt
            )

            guard let accessToken = await authMan.accessToken() else { return }
            let result = await memosService.createMemo(dto: dto, accessToken: accessToken)

            switch result {
            case .success:
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
