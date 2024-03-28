//
//  Memo.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct Memo: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let title: String
    let description: String?
    let priority: Int
    let status: String
    let visibility: Int
    let frequency: String?
    let triggerAt: Int
    let updatedAt: Int
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case description = "description"
        case priority = "priority"
        case status = "status"
        case visibility = "visibility"
        case frequency = "frequency"
        case triggerAt = "trigger_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }

    enum Priority: Int {
        case high = 3
        case medium = 2
        case low = 1
        case none = 0

        static func displayName(value: Int) -> String {
            switch value {
            case Priority.high.rawValue:
                return "High"
            case Priority.medium.rawValue:
                return "Medium"
            case Priority.low.rawValue:
                return "Low"
            default:
                return "Priority"
            }
        }
    }

    enum Status: String {
        case pending = "pending"
        case complete = "completed"
        case deleted = "deleted"
    }

    enum Visibility: Int {
        case pub = 1
        case priv = 0
    }

    enum Frequency: String {
        case hourly = "hourly"
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"

        var calendarComponent: Calendar.Component {
            switch self {
            case .hourly:
                return .hour
            case .daily:
                return .day
            case .weekly:
                return .weekOfYear
            case .monthly:
                return .month
            case .yearly:
                return .year
            }
        }
    }

    func nextEffectiveTriggerAt(fromCurrent timeInMilliseconds: Int) -> Int {
        guard let frequency = self.frequency else { return self.triggerAt }

        let difference = timeInMilliseconds - self.triggerAt
        guard difference > 0 else { return self.triggerAt }

        switch frequency {
        case Frequency.hourly.rawValue:
            return (self.triggerAt + 3600000) + difference
        case Frequency.daily.rawValue:
            return (self.triggerAt + 86400000) + difference
        case Frequency.weekly.rawValue:
            return (self.triggerAt + 604800000) + difference
        case Frequency.monthly.rawValue:
            return (self.triggerAt + 2629746000) + difference
        case Frequency.yearly.rawValue:
            return (self.triggerAt + 31556952000) + difference
        default:
            return self.triggerAt
        }
    }

    func toLocalNotification() -> LocalNotification {
        return LocalNotification(
            id: self.id,
            title: self.description == nil ? "Perroquet says:" : self.title,
            description: self.description == nil ? self.title : self.description!,
            frequency: self.frequency,
            triggerAt: self.triggerAt
        )
    }

    static func randomPlaceholder() -> String {
        return [
            "drink more water",
            "do laundry in 2 hours",
            "mow the lawn this afternoon",
            "redeem points tomorrow",
            "rate Perroquet",
            "feed parrot",
            "thaw food by noon",
            "water plants in 15 minutes",
            "take out the trash tonight",
            "replace filter at 2:30 pm",
            "clean room on thursday"
        ].randomElement()!
    }
}
