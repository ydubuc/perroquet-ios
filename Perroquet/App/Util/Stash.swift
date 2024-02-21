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
    static let DIR_PATH = "stash"
    static let DB_NAME = "defaultdb.sqlite3"
    
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
            createTables()
            print("SQLiteDataStore init successfully at: \(dbPath) ")
        } catch {
            db = nil
            print("SQLiteDataStore init error: \(error)")
        }
    }

    private func createTables() {
        guard let db = db else { return }
        
        do {
            try db.run(Table("reminders").create { table in
                table.column(Expression<Blob>("id"))
//                table.column(taskName)
//                table.column(date)
//                table.column(status)
            })
        } catch {
            print(error)
        }
    }

    let users = Table("users")
    let id = Expression<Blob>("id")

    private func createUsersTable() {
        guard let db = db else { return }
        
        do {
            try db.run(users.create { table in
                table.column(id, primaryKey: true)
            })
        } catch {
            print(error)
        }
    }
}
