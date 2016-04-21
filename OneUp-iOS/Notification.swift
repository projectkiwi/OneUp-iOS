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
    
    
    init(author: String, statusChange: String, timeStamp: String) {
        self.author = author
        self.statusChange = statusChange
        self.timeStamp = timeStamp
    }
}
