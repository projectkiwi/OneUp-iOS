//
//  NSDateExtension.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/10/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

public extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   != 0 { return "\(abs(yearsFrom(date)))y"   }
        if monthsFrom(date)  != 0 { return "\(abs(monthsFrom(date)))M"  }
        if weeksFrom(date)   != 0 { return "\(abs(weeksFrom(date)))w"   }
        if daysFrom(date)    != 0 { return "\(abs(daysFrom(date)))d"    }
        if hoursFrom(date)   != 0 { return "\(abs(hoursFrom(date)))h"   }
        if minutesFrom(date) != 0 { return "\(abs(minutesFrom(date)))m" }
        if secondsFrom(date) != 0 { return "\(abs(secondsFrom(date)))s" }
        return ""
    }
}