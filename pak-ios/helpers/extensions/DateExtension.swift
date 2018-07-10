//
//  DateExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/7/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    var nextMonth: Date {
         return Calendar.current.date(byAdding: .day, value: 30, to: noon)!
    }
    func toString(dateFormat format : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        return dateFormatter.string(from : self)
    }
}
