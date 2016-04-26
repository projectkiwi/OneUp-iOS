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
    var likedIDs: NSArray?
    var associatedIds: NSArray?
    var avatarImgUrl: String?
    
    init(userDetails: NSDictionary) {
        username = userDetails["username"] as? String ?? "no username"
        facebookID = userDetails["facebook_id"] as? String ?? "no ID"
        email = userDetails["email"] as? String ?? "no email"

        bookmarkIDs = userDetails["bookmarks"] as? [String]
        likedIDs = userDetails["liked_challenges"] as? [String]
        associatedIds = userDetails["associated_challenges"] as? [String]
        
        avatarImgUrl = userDetails["avatar"] as? String
    }
}