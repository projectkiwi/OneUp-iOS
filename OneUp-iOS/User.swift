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
//    var associatedChallenges: [Challenge]
    
//    username: String,
//    facebook_id: String,
//    email: String,
//    settings: [String],
//    bookmarks: [{ type: mongoose.Schema.ObjectId, ref: 'Challenge' }],
//    associated_challenges: [{ type: mongoose.Schema.ObjectId, ref: 'Challenge' }],
//    records: [{ type: mongoose.Schema.ObjectId, ref: 'Challenge' }],
//    liked_challenges: [{ type: mongoose.Schema.ObjectId, ref: 'Challenge' }]
    
    init(userDetails: NSDictionary) {
        username = userDetails["username"] as? String ?? "no username"
        facebookID = userDetails["facebook_id"] as? String ?? "no ID"
        email = userDetails["email"] as? String ?? "no email"

        bookmarkIDs = userDetails["bookmarks"] as? [String]
        
//        ApiClient.getBookmarks { (bookmarkIDs, error) in
//            if error == nil {
//                self.bookmarkIDs = bookmarkIDs
//            }
//        }
    
//        for challengeID in userDetails["liked_challenges"] as! NSArray {
//            print(challengeID)
//            ApiClient.getChallenge(challengeID as! String, params: nil, completion: { (challenge, error) in
//                let challenge = challenge
//                print(challenge)
//            })
//        }
//        bookmarks = nil
//        associatedChallenges = nil
    }
}