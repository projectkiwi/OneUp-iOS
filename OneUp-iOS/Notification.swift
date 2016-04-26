//
//  Notification.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/20/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

class Notification {
    
    var authorImgUrl: String?
    var author: String?
    var statusChange: String?
    var timeStamp: String?
    var challenge: Challenge?
    var challengeID: String?
    
    init(author: String, statusChange: String, timeStamp: String) {
        self.author = author
        self.statusChange = statusChange
        self.timeStamp = timeStamp
    }
    
    init(notificationDetails: NSDictionary) {
        
        author = notificationDetails["from"]!["username"] as? String ?? "NO FROM"
        authorImgUrl = notificationDetails["from"]!["avatar"] as? String ?? ""
        statusChange = notificationDetails["text"] as? String ?? "NO DESCRIPTION"
        
        challengeID = notificationDetails["challenge"]!["_id"] as? String
        
        if let createdAtString = notificationDetails["date"] as? String {
            let createdAtDate = createdAtString.dateFromString(createdAtString)
            let currentDate = NSDate()
            timeStamp = currentDate.offsetFrom(createdAtDate!)
        } else {
            timeStamp = "ER"
        }
    }
}
