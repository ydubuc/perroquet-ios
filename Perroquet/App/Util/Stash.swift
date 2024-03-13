//
//  Stash.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation
import SQLiteSwift

class Stash {
    static let shared = Stash()
    private static let DIR_PATH = "stash"
    private static let DB_NAME = "defaultdb.sqlite3"
    private static let VERSION = 1

    private var db: Connection?

    private init() {
        guard let docDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            return
        }

        let dirPath = docDir.appendingPathComponent(Stash.DIR_PATH)

        do {
            try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
            let dbPath = dirPath.appendingPathComponent(Stash.DB_NAME).path
            db = try Connection(dbPath)
            createMemosTable()
        } catch {
            db = nil
            print("sqlite init error: \(error)")
        }
    }

    func clear() {
        guard let db = db else { return }

        do {
            try db.run(Stash.MEMOS_TABLE.drop(ifExists: true))
            createMemosTable()
        } catch {
            print(error)
        }
    }

    static let MEMOS_TABLE = Table("memos_v\(VERSION)")

    private let MEMO_ID = Expression<String>("id")
    private let MEMO_USER_ID = Expression<String>("user_id")
    private let MEMO_TITLE = Expression<String>("title")
    private let MEMO_DESCRIPTION = Expression<String?>("description")
    private let MEMO_PRIORITY = Expression<String?>("priority")
    private let MEMO_STATUS = Expression<String>("status")
    private let MEMO_VISIBILITY = Expression<Int>("visibility")
    private let MEMO_FREQUENCY = Expression<String?>("frequency")
    private let MEMO_TRIGGER_AT = Expression<Int>("trigger_at")
    private let MEMO_UPDATED_AT = Expression<Int>("updated_at")
    private let MEMO_CREATED_AT = Expression<Int>("created_at")

    private func createMemosTable() {
        guard let db = db else { return }

        do {
            try db.run(Stash.MEMOS_TABLE.create(ifNotExists: true) { table in
                table.column(MEMO_ID, primaryKey: true)
                table.column(MEMO_USER_ID)
                table.column(MEMO_TITLE)
                table.column(MEMO_DESCRIPTION)
                table.column(MEMO_PRIORITY)
                table.column(MEMO_STATUS)
                table.column(MEMO_VISIBILITY)
                table.column(MEMO_FREQUENCY)
                table.column(MEMO_TRIGGER_AT)
                table.column(MEMO_UPDATED_AT)
                table.column(MEMO_CREATED_AT)
            })
        } catch {
            print(error)
        }
    }

    func insertMemos(memos: [Memo]) {
        for memo in memos {
            insertMemo(memo: memo)
        }
    }

    func insertMemo(memo: Memo) {
        guard let db = db else { return }

        do {
            _ = try db.run(Stash.MEMOS_TABLE.insert(
                or: .replace,
                MEMO_ID <- memo.id,
                MEMO_USER_ID <- memo.userId,
                MEMO_TITLE <- memo.title,
                MEMO_DESCRIPTION <- memo.description,
                MEMO_PRIORITY <- memo.priority,
                MEMO_VISIBILITY <- memo.visibility,
                MEMO_FREQUENCY <- memo.frequency,
                MEMO_TRIGGER_AT <- memo.triggerAt,
                MEMO_UPDATED_AT <- memo.updatedAt,
                MEMO_CREATED_AT <- memo.createdAt
            ))
        } catch {
            print(error)
        }
    }

    func getMemos(dto: GetMemosDto? = nil) -> [Memo]? {
        guard let db = db else { return nil }

        do {
            var memos: [Memo] = []

            for row in try db.prepare(Stash.MEMOS_TABLE) {
                let memo = Memo(
                    id: row[MEMO_ID],
                    userId: row[MEMO_USER_ID],
                    title: row[MEMO_TITLE],
                    description: row[MEMO_DESCRIPTION],
                    priority: row[MEMO_PRIORITY],
                    status: row[MEMO_STATUS],
                    visibility: row[MEMO_VISIBILITY],
                    frequency: row[MEMO_FREQUENCY],
                    triggerAt: row[MEMO_TRIGGER_AT],
                    updatedAt: row[MEMO_UPDATED_AT],
                    createdAt: row[MEMO_CREATED_AT]
                )
                memos.append(memo)
            }

            return memos
        } catch {
            print(error)
            return nil
        }
    }

    func updateMemo(memo: Memo) {
        guard let db = db else { return }

        do {
            let row = Stash.MEMOS_TABLE.filter(MEMO_ID == memo.id)
            try db.run(row.update(memo))
        } catch {
            print(error)
            return
        }
    }

    func deleteMemo(id: String) {
        guard let db = db else { return }

        do {
            let row = Stash.MEMOS_TABLE.filter(MEMO_ID == id)
            try db.run(row.delete())
        } catch {
            print(error)
            return
        }
    }
}
