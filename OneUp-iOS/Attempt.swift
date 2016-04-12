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
    var imgUrl: String!
    var gifUrl: String!
    var videoURL: String!
    var description: String!
    var votes: Int!
    var likes: Int! { get { return votes } }
    var isLiked: Bool!
    var comments: NSArray!
    
    init(attemptDetails: NSDictionary) {
        id = attemptDetails["_id"] as! String
        imgUrl = attemptDetails["gif_img"] as? String ?? ""
        gifUrl = attemptDetails["gif_img"] as? String ?? ""
        videoURL = attemptDetails["orig_video"] as? String ?? ""
        description = attemptDetails["description"] as? String ?? ""
        votes = attemptDetails["like_total"] as? Int ?? 0
        isLiked = attemptDetails["liked_attempt"] as? Bool ?? false
        comments = attemptDetails["comments"] as? NSArray ?? []
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