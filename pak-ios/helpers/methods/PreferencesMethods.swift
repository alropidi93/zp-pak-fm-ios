//
//  PreferencesMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation

class PreferencesMethods {
    static func getUserFromOptions() -> UserDC? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "userData")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? UserDC
        }
    }
    
    static func saveUserToOptions(_ userDC : UserDC) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: userDC)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "userData")
    }
    
    static func logoutUserFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userData")
        defaults.set(nil, forKey: "firstTime")
    }
    
    
    static func getSmallBoxFromOptions() -> SmallBoxDC? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "smallBoxData")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? SmallBoxDC
        }
    }
    
    static func saveSmallBoxToOptions(_ smallBoxDC : SmallBoxDC) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: smallBoxDC)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "smallBoxData")
    }
    
    static func deleteSmallBoxFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "smallBoxData")
        
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

