//
//  AppDelegate.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Alamofire
import SwiftyJSON
import Fabric
import IQKeyboardManagerSwift
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let gcmMessageIDKey : String = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
       }

    func applicationDidEnterBackground(_ application: UIApplication) {
       }

    func applicationWillEnterForeground(_ application: UIApplication) {
        }

    func applicationDidBecomeActive(_ application: UIApplication) {
        }

    func applicationWillTerminate(_ application: UIApplication) {
       }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        if let urlForMainTask = userInfo[AppDelegate.gcmMessageIDKey] {
            print("Message ID: \(urlForMainTask)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "url_from_notification"), object: nil, userInfo: userInfo)
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token: \(fcmToken)")
        
        let pakUser = ConstantsModels.UserStatic
        if pakUser == nil {
            return
        }
        
        let params: Parameters = [
            "userid": pakUser!.idUser,
            "fcmtoken": fcmToken
        ]
        
        Alamofire.request(URLs.refreshToken, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            if response.response == nil {
                print("Connection error")
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                pakUser?.accessToken = fcmToken
                ConstantsModels.UserStatic = pakUser!
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    print("\(jsonResult["message"].string!)")
                } else {
                    print("Undocumented error")
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

