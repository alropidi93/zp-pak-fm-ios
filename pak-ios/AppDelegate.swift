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
import IQKeyboardManagerSwift
import GoogleSignIn
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static let gcmMessageIDKey : String = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        
        
        
        
        
        //
        //        FirebaseApp.configure()
        //        Messaging.messaging().delegate = self
        //        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            /*UNUserNotificationCenter.current().delegate = self
             
             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(
             options: authOptions,
             completionHandler: {_, _ in })
             */
            
            
            /* MARK BEGIN: Added by Alvaro according tutorial*/
            
            UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge]){(isGranted,err) in
                if err != nil {
                    //Something bad happened
                    print("Something bad happened")
                }
                else{
                    UNUserNotificationCenter.current().delegate = self
                    Messaging.messaging().delegate = self
                    DispatchQueue.main.async{ /* focus here, I think this may be the solution*/
                        application.registerForRemoteNotifications()
                    }
                    
                    
                }
                
                
            }
            
            /*MARK END*/
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        let meowAction = UNNotificationAction(identifier: "calificar", title: "Calificar", options: [])
        
        let category = UNNotificationCategory(identifier: "myCategoryName", actions: [meowAction], intentIdentifiers: [], options: [])
        
        
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        /* MARK BEGIN: Added by Alvaro accoRding tutorial*/
        
        FirebaseApp.configure() /*according the tutorial, this line must be inmediatly before the return*/
        
        /*MARK END*/
        return true
    }
    
    /* MARK BEGIN: Added by Alvaro accoRding tutorial*/
    func ConnectToFCM(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    /*MARK END*/
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        /* MARK BEGIN: Added by Alvaro according tutorial*/
        ConnectToFCM()
        /* MARK END*/
    }
    
    func applicationWillTerminate(_ application: UIApplication) { }
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
     if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
     print("Message ID: \(messageID)")
     }
     print(userInfo)
     }*/
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
     print("Message ID: \(messageID)")
     }
     print(userInfo)
     if let urlForMainTask = userInfo[AppDelegate.gcmMessageIDKey] {
     print("Message ID: \(urlForMainTask)")
     }
     completionHandler(UIBackgroundFetchResult.newData)
     }*/
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("APNs token retrieved : \(deviceToken)")
    }
    
    //AMD
    //
    /*func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
     let token = Messaging.messaging().fcmToken
     print("FCM token: \(token ?? "")")
     }*/
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification (depreceated) - Background")
        print(userInfo as AnyObject)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification - Background")
        print(userInfo as AnyObject)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive - Foreground")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo as AnyObject)
        print("Action ID: \(response.actionIdentifier)")
        //esto abre el rating
        //let cliente = userInfo["cliente"] as? String ?? "Usuario"
        let tipo = userInfo["tipo"] as? String ?? "Error"
        if tipo == "pedido_entregado" {
            NotificationCenter.default.post(name: .viewNotification, object: nil, userInfo: userInfo)
        }else if tipo == "pedido_proximo" {
            //aqui se muestra el pedido proximo
            NotificationCenter.default.post(name: .viewProximo, object: nil, userInfo: userInfo)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent - Foreground")
        let userInfo = notification.request.content.userInfo
        print(userInfo as AnyObject)
        
        //NotificationCenter.default.post(name: .viewNotification, object: nil, userInfo: nil)
        
        
        completionHandler([.alert, .sound])
    }
    // amd
    //....
    
    
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    /*
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     let userInfo = notification.request.content.userInfo
     // With swizzling disabled you must let Messaging know about the message, for Analytics
     // Messaging.messaging().appDidReceiveMessage(userInfo)
     if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
     print("Message ID: \(messageID)")
     }
     // Print full message.
     print(userInfo)
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pedido_entregado"), object: nil, userInfo: userInfo)
     // Change this to your preferred presentation option
     completionHandler([.alert])
     }
     
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     let userInfo = response.notification.request.content.userInfo
     // Print message ID.
     if let messageID = userInfo[AppDelegate.gcmMessageIDKey] {
     print("Message ID: \(messageID)")
     }
     if response.actionIdentifier == "calificar" {
     NotificationCenter.default.post(name: .viewNotification, object: nil, userInfo: nil)
     }
     
     completionHandler()
     }*/
}

// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token: \(fcmToken)")
        
        let pakUser = ConstantsModels.static_user
        if pakUser == nil {
            return
        }
        
        let params: Parameters = [
            "userid": pakUser!.idUser,
            "fcmtoken": fcmToken
        ]
        //codigo dudoso
        Alamofire.request(URLs.refreshToken, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            if response.response == nil {
                print("Connection error")
                return
            }
            
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                pakUser?.accessToken = fcmToken
                ConstantsModels.static_user = pakUser!
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
        if remoteMessage.appData[AnyHashable("tipo")] as! String == "pedido_proximo" {
            let content = UNMutableNotificationContent()
            let horario : String = (remoteMessage.appData[AnyHashable("horaInicio")] as! String) + " - " + (remoteMessage.appData[AnyHashable("horaFin")] as! String)
            content.title = "¡Hola" + (remoteMessage.appData[AnyHashable("cliente")] as! String) + "!"
            content.subtitle = "Mañana llegará tu PAK entre las" + horario + "."
            content.badge = 1
            content.categoryIdentifier = "pedidoProximo"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            
            
        }else if remoteMessage.appData[AnyHashable("tipo")] as! String == "pedido_entregado"{
            let content = UNMutableNotificationContent()
            content.title = "¡Has recibido tu cajita!"
            content.subtitle = "Ayúdanos a mejorar calificando el servicio."
            content.badge = 1
            content.categoryIdentifier = "myCategoryName"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            let numberString : String = (remoteMessage.appData[AnyHashable("numero")] as! String)
            let numberInt : Int = Int(numberString)!
            ConstantsModels.numberBox = numberInt
        }
        
        
    }
    
    
    // [END ios_10_data_message]
}



