//
//  StringExtension.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/20/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

extension String {
    
    func dateFromString(dateString: String) -> NSDate? {
//        let dateString = "2014-07-06T07:59:00Z"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //"yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return dateFormatter.dateFromString(dateString)
    }
}
