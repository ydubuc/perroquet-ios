//
//  Stash.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation
import SQLite

class Stash {
    static let shared = Stash()
    private static let DIR_PATH = "stash"
    private static let DB_NAME = "defaultdb.sqlite3"
    
    private var db: Connection? = nil
    
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
            print("SQLiteDataStore init successfully at: \(dbPath) ")
        } catch {
            db = nil
            print("SQLiteDataStore init error: \(error)")
        }
    }

    static let REMINDERS = Table("reminders")
    
    private let id = Expression<String>("id")
    private let userId = Expression<String>("user_id")
    private let title = Expression<String?>("title")
    private let body = Expression<String>("body")
    private let frequency = Expression<String?>("frequency")
    private let visibility = Expression<Int>("visibility")
    private let triggerAt = Expression<Int>("trigger_at")
    private let updatedAt = Expression<Int>("updated_at")
    private let createdAt = Expression<Int>("created_at")

    private func createRemindersTable() {
        guard let db = db else { return }
        
        do {
            try db.run(Stash.REMINDERS.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(userId)
                table.column(title)
                table.column(body)
                table.column(frequency)
                table.column(visibility)
                table.column(triggerAt)
                table.column(updatedAt)
                table.column(createdAt)
            })
            
            print("created reminders table")
        } catch {
            print(error)
        }
    }
    
    func cacheReminders(reminders: [Reminder]) {
        for reminder in reminders {
            cacheReminder(reminder: reminder)
        }
    }
    
    func cacheReminder(reminder: Reminder) {
        guard let db = db else { return }
        
        do {
            let _ = try db.run(Stash.REMINDERS.insert(or: .replace, encodable: reminder))
        } catch {
            print(error)
        }
    }
    
    func getReminders(dto: GetRemindersFilterDto? = nil) -> [Reminder]? {
        guard let db = db else { return nil }
        
        do {
            var reminders: [Reminder] = []
            
            for row in try db.prepare(Stash.REMINDERS) {
                let reminder = Reminder(
                    id: row[id],
                    userId: row[userId],
                    title: row[title],
                    body: row[body],
                    frequency: row[frequency],
                    visibility: row[visibility],
                    triggerAt: row[triggerAt],
                    updatedAt: row[updatedAt],
                    createdAt: row[createdAt]
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
            let row = Stash.REMINDERS.filter(id == reminder.id)
            try db.run(row.update(reminder))
        } catch {
            print(error)
            return
        }
    }
    
    func deleteReminder(id reminderId: String) {
        guard let db = db else { return }
        
        do {
            let row = Stash.REMINDERS.filter(id == reminderId)
            try db.run(row.delete())
        } catch {
            print(error)
            return
        }
    }
}
