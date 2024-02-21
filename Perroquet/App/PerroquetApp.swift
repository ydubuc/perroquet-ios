//
//  PerroquetApp.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct PerroquetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var appVm = AppViewModel.shared
    @StateObject var authMan = AuthMan.shared
    
    var body: some Scene {
        
        WindowGroup {
            if authMan.isLoggedIn {
                MainView()
            } else {
                SigninView()
            }
        }
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let devicesService = DevicesService(url: Config.BACKEND_URL)
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        requestRegisterForNotifications()
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func requestRegisterForNotifications() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { [weak self] (granted, _) in
            guard granted else { return }

            self?.registerForRemoteNotifications()
        }
    }

    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")

        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("didReceiveRemoteNotification: \(userInfo)")

        Messaging.messaging().appDidReceiveMessage(userInfo)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        print("didReceiveRemoteNotification async: \(userInfo)")

        Messaging.messaging().appDidReceiveMessage(userInfo)

        return .newData
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        print("userNotificationCenter willPresent: \(notification.request.content.userInfo)")

        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)

        return [[.banner, .sound]]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        print("userNotificationCenter didReceive: \(userInfo)")

        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: ["token": fcmToken ?? ""]
        )

        guard let messagingToken = fcmToken
        else {
            AuthMan.shared.deleteCachedMessagingToken()
            return
        }

        AuthMan.shared.onNewMessagingToken(messagingToken: messagingToken)
    }
}
