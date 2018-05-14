//
//  UtilMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/25/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UtilMethods {
    /** #MARK: [Color]  Color methods */
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /** #MARK: [UI] Image methods */
    static func setImage(imageview: UIImageView, imageurl: String, placeholderurl: String){
        imageview.sd_setShowActivityIndicatorView(true)
        imageview.sd_setIndicatorStyle(.gray)
        imageview.sd_setImage(with: URL(string: imageurl), placeholderImage: UIImage(named: placeholderurl))
    }
    
    static func roundImage(imageview: UIImageView){
        imageview.layer.cornerRadius = imageview.frame.size.width / 2;
        imageview.clipsToBounds = true;
        imageview.layer.shadowOffset = CGSize(width: 10, height: 10)
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.shadowOpacity = 0.5
    }
    
    /** #MARK: [UI] Refresh controller methods */
    static func customizeRefreshControl(refreshControl : UIRefreshControl) {
        refreshControl.tintColor = UtilMethods.hexStringToUIColor(hex: Constants.GOLD)
        refreshControl.attributedTitle = NSAttributedString(string: "Refrescando", attributes: nil)
    }
    
    /** #MARK: [Date] Date methods */
    static func dateIsToday(_ date : Date) -> Bool {
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date) {
            return true
        } else {
            return false
        }
    }
    
    static func intFromDate(_ referencialDate : Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: referencialDate)
        let month = calendar.component(.month, from: referencialDate)
        let day = calendar.component(.day, from: referencialDate)
        return year * 10000 + month * 100 + day
    }
    
    static func formatDate(_ dateToFormat : Date) -> String {
        var formattedDate : String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        formattedDate = dateFormatter.string(from: dateToFormat)
        return formattedDate
    }
    
    static func DateToString(_ date : String) -> String {
        var month : String = ""
        
        switch (date) {
            
        case "Jan":
            month = "01"
            return month
        case "Feb":
            month = "02"
            return month
        case "Mar":
            month = "03"
            return month
        case "Apr":
            month = "04"
            return month
        case "May":
            month = "05"
            return month
        case "Jun":
            month = "06"
            return month
        case "Jul":
            month = "07"
            return month
        case "Aug":
            month = "08"
            return month
        case "Sep":
            month = "09"
            return month
        case "Oct":
            month = "10"
            return month
        case "Nov":
            month = "11"
            return month
        case "Dec":
            month = "12"
            return month
        default:
            month = "00"
            return month
        }
    }
    
    
    static func dateToSlash(_ dateToFormat : String) -> String {
        
        let date : [String] = dateToFormat.components(separatedBy: "-")
        let day : String = date[0]
        let month : String = DateToString(date[1])
        let year : String = date[2]
        let date2: String = day + "/" + month + "/" + year
        return date2
    }
    
    
    static func formatDate(dateFromInt : Int) -> String {
        let years = dateFromInt / 10000
        
        let months = (dateFromInt % 10000) / 100
        let truemonths = months<10 ? "0\(months)" : "\(months)"
        
        let days = dateFromInt % 100
        let truedays = days<10 ? "0\(days)" : "\(days)"
        
        return "\(truedays)-\(truemonths)-\(years)"
    }
    
    
    
    static func presentationTime(_ time : Int) -> String {
        if time < 10 {
            return "0\(time)"
        }
        return "\(time)"
    }
    
    static func dayDistance(_ beginDate: Date, endDate : Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: beginDate, to: endDate)
        if (components.day ?? 0) > 0 {
            return components.day!
        } else {
            return 0
        }
    }
}