//
//  AppDelegate.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
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


}

