//
//  Attempt.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

class Attempt {
    
    var id: String
    var author: String
    var imgUrl: String
    var gifUrl: String
    var videoUrl: String
    var description: String
    var votes: Int
    var likes: Int { get { return votes } }
    var isLiked: Bool
    var comments: NSArray!
    
    init(attemptDetails: NSDictionary) {
        id = attemptDetails["_id"] as! String
        author = attemptDetails["author"] as? String ?? "IOS Author Placeholder - Waiting Backend Support"
        if let imgFile = attemptDetails["gif_img"] as? String {
            imgUrl = "\(ApiClient.apiURL)/\(imgFile)"
        } else {
            imgUrl = "http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif"
        }
        if let gifFile = attemptDetails["gif_img"] as? String {
            gifUrl = "\(ApiClient.apiURL)/\(gifFile)"
        } else {
            gifUrl = "http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif"
        }
        if let videoFile = attemptDetails["orig_video"] as? String {
            videoUrl = "\(ApiClient.apiURL)/\(videoFile)"
        } else {
            videoUrl = "http://kiwiapi.purduecs.com/uploads/challenge_attempts/570afb565c4f232826fddcbe_570ad3335c4f232826fddc9a_1460337522415_orig.mp4"
        }
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