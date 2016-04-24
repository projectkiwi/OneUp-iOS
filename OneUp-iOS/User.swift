//
//  User.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/14/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

class User {
 
    var username: String
    var facebookID: String
    var email: String
    var bookmarkIDs: NSArray?
    var avatarImgUrl: String?
    
    init(userDetails: NSDictionary) {
        username = userDetails["username"] as? String ?? "no username"
        facebookID = userDetails["facebook_id"] as? String ?? "no ID"
        email = userDetails["email"] as? String ?? "no email"

        bookmarkIDs = userDetails["bookmarks"] as? [String]
        avatarImgUrl = userDetails["avatar"] as? String
    }
}