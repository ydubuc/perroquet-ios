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
    let memosService: MemosService

    @Published var theme: Theme

    @Published var isPresentingCreateMemoView = false

    private var lastAppRefresh = Date().timeIntervalSince1970.milliseconds

    init(
        notificator: Notificator = Notificator(),
        memosService: MemosService = MemosService(url: Config.BACKEND_URL)
    ) {
        self.notificator = notificator
        self.memosService = memosService

        self.theme = SlateTheme()
    }

    func refreshApp(authMan: AuthMan) async {
        guard let accessToken = await authMan.accessToken() else { return }

        let result = await memosService.getMemos(
            dto: .init(
                id: nil,
                userId: authMan.accessTokenClaims?.id,
                search: nil,
                priority: nil,
                status: "pending",
                visibility: nil,
                sort: "updated_at,asc",
                cursor: "\(lastAppRefresh),\(UUID().uuidString.lowercased())",
                limit: nil
            ),
            accessToken: accessToken
        )

        self.lastAppRefresh = Date().timeIntervalSince1970.milliseconds

        switch result {
        case .success(let memos):
            scheduleMemos(memos: memos)
        case .failure(let apiError):
            print(apiError.message)
            return
        }
    }

    func scheduleMemos(memos: [Memo]?) {
        let memos = memos ?? Stash.shared.getMemos() ?? []

        Task {
            for memo in memos {
                if memo.status == Memo.Status.complete.rawValue {
                    notificator.delete(ids: [memo.id])
                } else {
                    await notificator.schedule(notification: memo.toLocalNotification())
                }
            }
        }
    }
}
