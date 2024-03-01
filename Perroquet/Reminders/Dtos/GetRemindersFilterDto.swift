//
//  GetRemindersFilterDto.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

struct GetRemindersFilterDto: QueryDto {
    let id: String?
    let userId: String?
    let search: String?
    let tags: String?
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
        if let tags = tags {
            queries.append(.init(name: "tags", value: tags))
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
