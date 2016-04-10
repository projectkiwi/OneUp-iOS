//
//  Attempt.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

class Attempt {
    
    var id: String!
    var votes: Int!
    var imgUrl: String!
    var gifUrl: String!
    var voteTotal: Int!
    
    init(attemptDetails: NSDictionary) {
        id = attemptDetails["_id"] as! String
        voteTotal = attemptDetails["like_total"] as! Int
        imgUrl = attemptDetails["gif_img"] as! String
        gifUrl = attemptDetails["gif_img"] as! String
    }

    class func attemptsFromArray(attemptArray: NSArray) -> [Attempt] {
        var attempts = [Attempt]()
        
        // loop through JSON to grab all challenges
        for attemptDetails in attemptArray {
            attempts.append(Attempt(attemptDetails: attemptDetails as! NSDictionary))
        }
        
        return attempts
    }
/*
    score: Number, //probably will make this a calculated field
    challenge  : { type: mongoose.Schema.ObjectId, ref: 'Challenge' },
    user  : { type: mongoose.Schema.ObjectId, ref: 'User' },
    preview_img  : String,
    full_img  : String,
    gif_img : String,
    comments  : [{ type: mongoose.Schema.ObjectId, ref: 'Comment' }],
    votes  : [{ type: mongoose.Schema.ObjectId, ref: 'Vote' }],
    vote_total : { type: Number, default: 11},
*/
}