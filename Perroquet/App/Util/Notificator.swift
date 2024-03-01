//
//  Notificator.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/20/24.
//

import Foundation
import UserNotifications

struct LocalNotification {
    let id: String
    let title: String
    let description: String
    let triggerAt: Int
}

class Notificator {
    func schedule(notification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.description
        content.sound = UNNotificationSound(named: .init("notification_perroquet.wav"))
        
        let timeInterval = TimeInterval(notification.triggerAt / 1000)
        let fireDate = Date(timeIntervalSince1970: timeInterval)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        do {
            try await notificationCenter.add(request)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func clearNotifications(ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func delete(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    func deleteAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
