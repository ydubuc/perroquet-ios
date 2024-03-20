//
//  MemoViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    let authMan: AuthMan
    let notificator: Notificator
    let stash: Stash
    let memosService: MemosService

    let memo: Memo
    let listener: MemoListener?

    @Published var title: String
    @Published var description: String
    @Published var priority: String
    @Published var status: String
    @Published var visibility: Int
    @Published var frequency: String
    @Published var triggerAtDate: Date

    @Published var placeholder = Memo.randomPlaceholder()

    @Published var isPresentingMemoActionsView = false
    @Published var isPresentingDatePickerView = false

    init(
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        stash: Stash = Stash.shared,
        memosService: MemosService = MemosService(url: Config.BACKEND_URL),
        memo: Memo,
        listener: MemoListener?
    ) {
        self.authMan = authMan
        self.notificator = notificator
        self.stash = stash
        self.memosService = memosService

        self.memo = memo
        self.listener = listener

        self.title = memo.title
        self.description = memo.description ?? ""
        self.priority = memo.priority ?? ""
        self.status = memo.status
        self.visibility = memo.visibility
        self.frequency = memo.frequency ?? ""
        self.triggerAtDate = Date(timeIntervalSince1970: TimeInterval(memo.triggerAt / 1000))
    }

    func editMemo() {
        Task {
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let triggerAt = triggerAtDate.timeIntervalSince1970.milliseconds
            let tempMemo = Memo(
                id: memo.id,
                userId: memo.userId,
                title: title,
                description: description.isEmpty ? nil : description,
                priority: priority.isEmpty ? nil : priority,
                status: status,
                visibility: visibility,
                frequency: frequency.isEmpty ? nil : frequency,
                triggerAt: triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: memo.createdAt
            )

            stash.insertMemo(memo: tempMemo)
            await notificator.schedule(notification: tempMemo.toLocalNotification())

            DispatchQueue.main.async {
                self.listener?.onEditMemo(tempMemo)
            }

            let dto = EditMemoDto(
                title: title,
                description: description.isEmpty ? nil : description,
                priority: priority.isEmpty ? nil : priority,
                status: status,
                visibility: visibility,
                frequency: frequency.isEmpty ? nil : frequency,
                triggerAt: triggerAt
            )

            guard let accessToken = await authMan.accessToken() else { return }
            let result = await memosService.editMemo(id: memo.id, dto: dto, accessToken: accessToken)

            switch result {
            case .success:
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }

    func deleteMemo() {
        Task {
            stash.deleteMemo(id: memo.id)
            notificator.delete(ids: [memo.id])

            DispatchQueue.main.async {
                self.listener?.onDeleteMemo(self.memo)
            }

            guard let accessToken = await authMan.accessToken() else { return }
            let result = await memosService.archiveMemo(id: memo.id, accessToken: accessToken)

            switch result {
            case .success:
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}
