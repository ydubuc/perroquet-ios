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
            createRemindersTable()
        } catch {
            db = nil
            print("sqlite init error: \(error)")
        }
    }

    func clear() {
        guard let db = db else { return }

        do {
            try db.run(Stash.REMINDERS_TABLE.drop(ifExists: true))
            createRemindersTable()
        } catch {
            print(error)
        }
    }

    static let REMINDERS_TABLE = Table("reminders_v\(VERSION)")

    private let REMINDER_ID = Expression<String>("id")
    private let REMINDER_USER_ID = Expression<String>("user_id")
    private let REMINDER_TITLE = Expression<String>("title")
    private let REMINDER_DESCRIPTION = Expression<String?>("description")
    private let REMINDER_TAGS = Expression<String?>("tags")
    private let REMINDER_FREQUENCY = Expression<String?>("frequency")
    private let REMINDER_VISIBILITY = Expression<Int>("visibility")
    private let REMINDER_TRIGGER_AT = Expression<Int>("trigger_at")
    private let REMINDER_UPDATED_AT = Expression<Int>("updated_at")
    private let REMINDER_CREATED_AT = Expression<Int>("created_at")

    private func createRemindersTable() {
        guard let db = db else { return }

        do {
            try db.run(Stash.REMINDERS_TABLE.create(ifNotExists: true) { table in
                table.column(REMINDER_ID, primaryKey: true)
                table.column(REMINDER_USER_ID)
                table.column(REMINDER_TITLE)
                table.column(REMINDER_DESCRIPTION)
                table.column(REMINDER_TAGS)
                table.column(REMINDER_FREQUENCY)
                table.column(REMINDER_VISIBILITY)
                table.column(REMINDER_TRIGGER_AT)
                table.column(REMINDER_UPDATED_AT)
                table.column(REMINDER_CREATED_AT)
            })
        } catch {
            print(error)
        }
    }

    func insertReminders(reminders: [Reminder]) {
        for reminder in reminders {
            insertReminder(reminder: reminder)
        }
    }

    func insertReminder(reminder: Reminder) {
        guard let db = db else { return }

        do {
            _ = try db.run(Stash.REMINDERS_TABLE.insert(
                or: .replace,
                REMINDER_ID <- reminder.id,
                REMINDER_USER_ID <- reminder.userId,
                REMINDER_TITLE <- reminder.title,
                REMINDER_DESCRIPTION <- reminder.description,
                REMINDER_TAGS <- reminder.tags?.joined(separator: ","),
                REMINDER_FREQUENCY <- reminder.frequency,
                REMINDER_VISIBILITY <- reminder.visibility,
                REMINDER_TRIGGER_AT <- reminder.triggerAt,
                REMINDER_UPDATED_AT <- reminder.updatedAt,
                REMINDER_CREATED_AT <- reminder.createdAt
            ))
        } catch {
            print(error)
        }
    }

    func getReminders(dto: GetRemindersFilterDto? = nil) -> [Reminder]? {
        guard let db = db else { return nil }

        do {
            var reminders: [Reminder] = []

            for row in try db.prepare(Stash.REMINDERS_TABLE) {
                let reminder = Reminder(
                    id: row[REMINDER_ID],
                    userId: row[REMINDER_USER_ID],
                    title: row[REMINDER_TITLE],
                    description: row[REMINDER_DESCRIPTION],
                    tags: row[REMINDER_TAGS]?.components(separatedBy: ","),
                    frequency: row[REMINDER_FREQUENCY],
                    visibility: row[REMINDER_VISIBILITY],
                    triggerAt: row[REMINDER_TRIGGER_AT],
                    updatedAt: row[REMINDER_UPDATED_AT],
                    createdAt: row[REMINDER_CREATED_AT]
                )
                reminders.append(reminder)
            }

            return reminders
        } catch {
            print(error)
            return nil
        }
    }

    func updateReminder(reminder: Reminder) {
        guard let db = db else { return }

        do {
            let row = Stash.REMINDERS_TABLE.filter(REMINDER_ID == reminder.id)
            try db.run(row.update(reminder))
        } catch {
            print(error)
            return
        }
    }

    func deleteReminder(id reminderId: String) {
        guard let db = db else { return }

        do {
            let row = Stash.REMINDERS_TABLE.filter(REMINDER_ID == reminderId)
            try db.run(row.delete())
        } catch {
            print(error)
            return
        }
    }
}
