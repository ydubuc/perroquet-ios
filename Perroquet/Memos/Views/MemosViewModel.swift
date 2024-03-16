//
//  MemosViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class MemosViewModel: ObservableObject, MemoListener {
    let authMan: AuthMan
    let stash: Stash
    let notificator: Notificator
    let memosService: MemosService

    @Published var memos: [Memo]
    @Published var todayMemos: [Memo]
    @Published var sevenDaysMemos: [Memo]
    @Published var laterMemos: [Memo]
    @Published var previousMemos: [Memo]

    @Published var userId: String?
    @Published var search: String?
    @Published var priority: String?
    @Published var status: String?
    @Published var visibility: Int?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?

    @Published var errorMessage: String = ""

    @Published var isLoading = false

    init(
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared,
        notificator: Notificator = Notificator(),
        memosService: MemosService = MemosService(url: Config.BACKEND_URL),
        memos: [Memo]? = nil,
        dto: GetMemosDto = .init()
    ) {
        self.authMan = authMan
        self.stash = stash
        self.notificator = notificator
        self.memosService = memosService

        let memos = memos ?? []
        self.memos = memos.isEmpty ? memos : memos.sorted { $0.updatedAt > $1.updatedAt }

        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()

        self.todayMemos = memos
            .filter { $0.triggerAt > currentTimestamp && $0.triggerAt < endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.sevenDaysMemos = memos
            .filter { $0.triggerAt > endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.laterMemos = memos
            .filter { $0.triggerAt > sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.previousMemos = memos
            .filter { $0.triggerAt < currentTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) > ($1.triggerAt, $1.updatedAt) }

        self.userId = dto.userId
        self.search = dto.search
        self.priority = dto.priority
        self.status = dto.status
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit
    }

    func load() async {
        guard let accessToken = await authMan.accessToken() else { return }

        let dto = GetMemosDto(
            id: nil,
            userId: userId,
            search: search,
            priority: priority,
            status: status,
            visibility: visibility,
            sort: sort,
            cursor: getCursor(sort: sort),
            limit: limit
        )

        let result = await memosService.getMemos(dto: dto, accessToken: accessToken)

        switch result {
        case .success(let memos):
            DispatchQueue.main.async {
                self.insertAndOrderMemos(newMemos: memos)
                self.scheduleMemos()
                self.isLoading = false
            }
        case .failure(let apiError):
            DispatchQueue.main.async {
                print(apiError.message)
                self.errorMessage = apiError.message
                self.isLoading = false
            }
        }
    }

    private func getCursor(sort: String?) -> String? {
        guard !memos.isEmpty else { return cursor }

        switch sort {
        case "trigger_at,asc":
            return "\(memos.first!.triggerAt),\(memos.first!.id)"
        case "trigger_at,desc":
            return "\(memos.last!.triggerAt),\(memos.last!.id)"
        case "updated_at,asc":
            return "\(memos.first!.updatedAt),\(memos.first!.id)"
        case "updated_at,desc":
            return "\(memos.last!.updatedAt),\(memos.last!.id)"
        case "created_at,asc":
            return "\(memos.first!.createdAt),\(memos.first!.id)"
        case "created_at,desc":
            return "\(memos.last!.createdAt),\(memos.last!.id)"
        default:
            fatalError("Sort not implemented.")
        }
    }

    func insertAndOrderMemos(newMemos: [Memo]) {
        let idSet = Set(newMemos.map { $0.id })

        var array = self.memos.filter { !idSet.contains($0.id) }

        if sort?.hasSuffix("asc") == true {
            array.insert(contentsOf: newMemos, at: 0)
        } else {
            array.append(contentsOf: newMemos)
        }

        self.memos = array

        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()

        self.todayMemos = self.memos
            .filter { $0.triggerAt > currentTimestamp && $0.triggerAt < endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.sevenDaysMemos = self.memos
            .filter { $0.triggerAt > endOfDayTimestamp && $0.triggerAt < sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.laterMemos = self.memos
            .filter { $0.triggerAt > sevenDaysTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
        self.previousMemos = self.memos
            .filter { $0.triggerAt < currentTimestamp }
            .sorted { ($0.triggerAt, $0.updatedAt) > ($1.triggerAt, $1.updatedAt) }
    }

    private func scheduleMemos() {
        Task {
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
            let memos = memos.filter { memo in
                memo.triggerAt > currentTimeInMillis || memo.frequency != nil
            }
            for memo in memos {
                await notificator.schedule(notification: memo.toLocalNotification())
            }
        }
    }

    func onCreateMemo(_ memo: Memo) {
        insertAndOrderMemos(newMemos: [memo])
    }

    func onEditMemo(_ memo: Memo) {
        insertAndOrderMemos(newMemos: [memo])
    }

    func onDeleteMemo(_ memo: Memo) {
        self.memos = self.memos.filter { $0.id != memo.id }
        self.todayMemos = self.todayMemos.filter { $0.id != memo.id }
        self.sevenDaysMemos = self.sevenDaysMemos.filter { $0.id != memo.id }
        self.laterMemos = self.laterMemos.filter { $0.id != memo.id }
        self.previousMemos = self.previousMemos.filter { $0.id != memo.id }
    }
}
