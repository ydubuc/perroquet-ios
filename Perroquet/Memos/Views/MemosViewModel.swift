//
//  MemosViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class MemosViewModel: ObservableObject {
    let authMan: AuthMan
    let stash: Stash
    let notificator: Notificator
    let memosService: MemosService

    @Published var memos: [Memo]
    @Published var todayMemos: [Memo]
    @Published var sevenDaysMemos: [Memo]
    @Published var laterMemos: [Memo]
    @Published var completedMemos: [Memo]

    @Published var userId: String?
    @Published var search: String?
    @Published var priority: String?
    @Published var status: String?
    @Published var visibility: Int?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?

    @Published var isLoading = true
    @Published var errorMessage: String = ""

    @Published var isShowingTodayMemos: Bool
    @Published var isShowingSevenDaysMemos: Bool
    @Published var isShowingLaterMemos: Bool
    @Published var isShowingCompletedMemos: Bool

    init(
        authMan: AuthMan = AuthMan.shared,
        stash: Stash = Stash.shared,
        notificator: Notificator = Notificator(),
        memosService: MemosService = MemosService(url: Config.BACKEND_URL),
        memos: [Memo] = [],
        dto: GetMemosDto = .init()
    ) {
        self.authMan = authMan
        self.stash = stash
        self.notificator = notificator
        self.memosService = memosService

        self.memos = memos.isEmpty ? memos : memos
            .filter { $0.status != Memo.Status.deleted.rawValue }
            .sorted { $0.updatedAt > $1.updatedAt }

        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()

        self.todayMemos = MemosViewModel.sortedTodayMemos(
            from: memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.sevenDaysMemos = MemosViewModel.sortedSevenDaysMemo(
            from: memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.laterMemos = MemosViewModel.sortedLaterMemos(
            from: memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.completedMemos = MemosViewModel.sortedCompletedMemos(
            from: memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )

        self.userId = dto.userId
        self.search = dto.search
        self.priority = dto.priority
        self.status = dto.status
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit

        self.isShowingTodayMemos = !UserDefaults.standard.bool(forKey: MemosViewModel.KEY_HIDE_TODAY_MEMOS)
        self.isShowingSevenDaysMemos = !UserDefaults.standard.bool(forKey: MemosViewModel.KEY_HIDE_SEVENDAYS_MEMOS)
        self.isShowingLaterMemos = !UserDefaults.standard.bool(forKey: MemosViewModel.KEY_HIDE_LATER_MEMOS)
        self.isShowingCompletedMemos = !UserDefaults.standard.bool(forKey: MemosViewModel.KEY_HIDE_COMPLETED_MEMOS)

        self.afterInit()
    }

    private func afterInit() {
        Task { await load() }
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

        self.memos = array.filter { $0.status != Memo.Status.deleted.rawValue }

        let currentTimestamp = Date().timeIntervalSince1970.milliseconds
        let endOfDayTimestamp = Calendar.endOfDayTimestamp()
        let sevenDaysTimestamp = Calendar.endOfDayTimestampAfterSevenDays()

        self.todayMemos = MemosViewModel.sortedTodayMemos(
            from: self.memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.sevenDaysMemos = MemosViewModel.sortedSevenDaysMemo(
            from: self.memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.laterMemos = MemosViewModel.sortedLaterMemos(
            from: self.memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
        self.completedMemos = MemosViewModel.sortedCompletedMemos(
            from: self.memos,
            currentTimestamp: currentTimestamp,
            endOfDayTimestamp: endOfDayTimestamp,
            sevenDaysTimestamp: sevenDaysTimestamp
        )
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
}

extension MemosViewModel {
    static let KEY_HIDE_TODAY_MEMOS = "hide_today_memos"
    static let KEY_HIDE_SEVENDAYS_MEMOS = "hide_sevendays_memos"
    static let KEY_HIDE_LATER_MEMOS = "hide_later_memos"
    static let KEY_HIDE_COMPLETED_MEMOS = "hide_completed_memos"

    func toggleIsShowingTodayMemos() {
        UserDefaults.standard.set(isShowingTodayMemos, forKey: MemosViewModel.KEY_HIDE_TODAY_MEMOS)
        isShowingTodayMemos = !isShowingTodayMemos
    }

    func toggleIsShowingSevenDaysMemos() {
        UserDefaults.standard.set(isShowingSevenDaysMemos, forKey: MemosViewModel.KEY_HIDE_SEVENDAYS_MEMOS)
        isShowingSevenDaysMemos = !isShowingSevenDaysMemos
    }

    func toggleIsShowingLaterMemos() {
        UserDefaults.standard.set(isShowingLaterMemos, forKey: MemosViewModel.KEY_HIDE_LATER_MEMOS)
        isShowingLaterMemos = !isShowingLaterMemos
    }

    func toggleIsShowingCompleted() {
        UserDefaults.standard.set(isShowingCompletedMemos, forKey: MemosViewModel.KEY_HIDE_COMPLETED_MEMOS)
        isShowingCompletedMemos = !isShowingCompletedMemos
    }
}

extension MemosViewModel {
    static func sortedTodayMemos(
        from memos: [Memo],
        currentTimestamp: Int,
        endOfDayTimestamp: Int,
        sevenDaysTimestamp: Int
    ) -> [Memo] {
        return memos
            .filter {
                let triggerAt = $0.nextEffectiveTriggerAt(fromCurrent: currentTimestamp)
                return triggerAt < endOfDayTimestamp && triggerAt < sevenDaysTimestamp && $0.status == Memo.Status.pending.rawValue
            }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
    }

    static func sortedSevenDaysMemo(
        from memos: [Memo],
        currentTimestamp: Int,
        endOfDayTimestamp: Int,
        sevenDaysTimestamp: Int
    ) -> [Memo] {
        return memos
            .filter {
                let triggerAt = $0.nextEffectiveTriggerAt(fromCurrent: currentTimestamp)
                return triggerAt > endOfDayTimestamp && triggerAt < sevenDaysTimestamp
            }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
    }

    static func sortedLaterMemos(
        from memos: [Memo],
        currentTimestamp: Int,
        endOfDayTimestamp: Int,
        sevenDaysTimestamp: Int
    ) -> [Memo] {
        return memos
            .filter {
                let triggerAt = $0.nextEffectiveTriggerAt(fromCurrent: currentTimestamp)
                return triggerAt > sevenDaysTimestamp
            }
            .sorted { ($0.triggerAt, $0.updatedAt) < ($1.triggerAt, $1.updatedAt) }
    }

    static func sortedCompletedMemos(
        from memos: [Memo],
        currentTimestamp: Int,
        endOfDayTimestamp: Int,
        sevenDaysTimestamp: Int
    ) -> [Memo] {
        return memos
            .filter {
                let triggerAt = $0.nextEffectiveTriggerAt(fromCurrent: currentTimestamp)
                return triggerAt < currentTimestamp && $0.status == Memo.Status.complete.rawValue
            }
            .sorted { ($0.triggerAt, $0.updatedAt) > ($1.triggerAt, $1.updatedAt) }
    }
}

extension MemosViewModel: MemoListener {
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
        self.completedMemos = self.completedMemos.filter { $0.id != memo.id }
    }
}
