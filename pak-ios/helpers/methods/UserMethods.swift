//
//  UserMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation

class UserMethods {
    static func getUserFromOptions() -> UserDC? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "userData")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? UserDC
        }
    }
    
    static func saveUserToOptions(_ UserDC : UserDC) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: UserDC)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "userData")
    }
    
    static func logoutUserFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userData")
        defaults.set(nil, forKey: "firstTime")
    }
    
    static func saveFirstTime() {
        let encodedFirstTime = NSKeyedArchiver.archivedData(withRootObject: true)
        let defaults = UserDefaults.standard
        defaults.set(encodedFirstTime, forKey: "firstTime")
    }
    
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "firstTime")
        if data == nil {
            return true
        } else {
            return false
        }
    }
}

