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
import BackgroundTasks

@main
struct PerroquetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var appVm = AppViewModel()
    @StateObject var authMan = AuthMan.shared

    var body: some Scene {

        WindowGroup {

            if authMan.isLoggedIn {
                MainView()
                    .environmentObject(appVm)
                    .onAppear {
                        scheduleAppRefresh()
                    }
            } else {
                SigninView()
                    .environmentObject(appVm)
            }

        }
        .backgroundTask(.appRefresh("com.beamcove.Perroquet.app-refresh")) {
            await scheduleAppRefresh()
            await appVm.refreshApp(authMan: authMan)
        }

    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.beamcove.Perroquet.app-refresh")
        request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

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

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        Messaging.messaging().appDidReceiveMessage(userInfo)

        return .newData
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)

        return [[.banner, .sound]]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let messagingToken = fcmToken
        else {
            AuthMan.shared.deleteCachedMessagingToken()
            return
        }

        AuthMan.shared.onNewMessagingToken(messagingToken: messagingToken)
    }
}
