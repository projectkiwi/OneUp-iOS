//
//  Attempt.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

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
    var timestamp: String?
//    var cachedGIFImage: UIImage?
    
    init(attemptDetails: NSDictionary) {
        id = attemptDetails["_id"] as! String
        author = "" // Default, Filled in later
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
        
        // Get Author
        if let attemptUser = attemptDetails["user"] as? NSDictionary {
            author = attemptUser["username"] as? String ?? "Error: Author"
        }
        
        // Create 2 character timestamp
        if let createdAtString = attemptDetails["created_on"] as? String {
            let createdAtDate = createdAtString.dateFromString(createdAtString)
            let currentDate = NSDate()
            timestamp = currentDate.offsetFrom(createdAtDate!)
            
        } else {
            timestamp = "ER"
        }
        
    }

    class func attemptsFromArray(attemptArray: NSArray) -> [Attempt] {
        var attempts = [Attempt]()
        
        // loop through JSON to grab all challenges
        for attemptDetails in attemptArray {
            attempts.append(Attempt(attemptDetails: attemptDetails as! NSDictionary))
        }
        
        return attempts.reverse()
    }
}