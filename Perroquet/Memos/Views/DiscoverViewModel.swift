//
//  DiscoverViewModel.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation
import SwiftUI

class DiscoverViewModel: ObservableObject, MemoListener {
    let authMan: AuthMan
    let notificator: Notificator
    let memosService: MemosService

    @Published var memos: [Memo] = []

    @Published var userId: String?
    @Published var search: String?
    @Published var priority: Int?
    @Published var status: String?
    @Published var visibility: Int?
    @Published var sort: String?
    @Published var cursor: String?
    @Published var limit: Int?

    @Published var errorMessage: String = ""

    init(
        authMan: AuthMan = AuthMan.shared,
        notificator: Notificator = Notificator(),
        memosService: MemosService = MemosService(url: Config.BACKEND_URL),
        dto: GetMemosDto
    ) {
        self.authMan = authMan
        self.notificator = notificator
        self.memosService = memosService

        self.userId = dto.userId
        self.search = dto.search
        self.priority = dto.priority
        self.status = dto.status
        self.visibility = dto.visibility
        self.sort = dto.sort
        self.cursor = dto.cursor
        self.limit = dto.limit

        self.afterInit()
    }

    private func afterInit() {
        Task { await self.load() }
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
            }
        case .failure(let apiError):
            DispatchQueue.main.async {
                print(apiError.localizedDescription)
                self.errorMessage = apiError.message
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
        array.append(contentsOf: newMemos)

        self.memos = array.sorted { $0.triggerAt > $1.triggerAt }
    }

    func onCreateMemo(_ memo: Memo) {
        print("on create")
    }

    func onEditMemo(_ memo: Memo) {
        print("on edit")
    }

    func onDeleteMemo(_ memo: Memo) {
        print("on delete")
    }
}
