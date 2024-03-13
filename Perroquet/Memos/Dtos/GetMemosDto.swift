//
//  GetMemosDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

struct GetMemosDto: QueryDto {
    let id: String?
    let userId: String?
    let search: String?
    let priority: String?
    let status: String?
    let visibility: Int?
    let sort: String?
    let cursor: String?
    let limit: Int?

    func toQueryItems() -> [URLQueryItem] {
        var queries: [URLQueryItem] = []

        if let id = id {
            queries.append(.init(name: "id", value: id))
        }
        if let userId = userId {
            queries.append(.init(name: "user_id", value: userId))
        }
        if let search = search {
            queries.append(.init(name: "search", value: search))
        }
        if let priority = priority {
            queries.append(.init(name: "priority", value: priority))
        }
        if let status = status {
            queries.append(.init(name: "status", value: status))
        }
        if let visibility = visibility {
            queries.append(.init(name: "visibility", value: "\(visibility)"))
        }
        if let sort = sort {
            queries.append(.init(name: "sort", value: sort))
        }
        if let cursor = cursor {
            queries.append(.init(name: "cursor", value: cursor))
        }
        if let limit = limit {
            queries.append(.init(name: "limit", value: "\(limit)"))
        }

        return queries
    }
}

extension GetMemosDto {
    init() {
        self.id = nil
        self.userId = nil
        self.search = nil
        self.priority = nil
        self.status = nil
        self.visibility = nil
        self.sort = nil
        self.cursor = nil
        self.limit = nil
    }
}
