//
//  PreferencesMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation

class PreferencesMethods {
    
    
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
    
    
    
    static func getAccessTokenFromOptions() -> String? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "accessToken")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? String
        }
    }
    
    static func saveAccessTokenToOptions(_ accessToken : String) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: accessToken)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "accessToken")
    }
    
    static func deleteAccessTokenFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "accessToken")
        
    }
    
    
    static func getIdFromOptions() -> UInt64? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "idUser")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? UInt64
        }
    }
    
    static func saveIdToOptions(_ id : UInt64) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: id)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "idUser")
    }
    
    static func deleteIdFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "idUser")
        
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

