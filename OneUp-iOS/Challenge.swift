//
//  Challenge.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

class Challenge {
    
    var name: String!
    var attempts: NSArray!
    var description: String?
    var categories: [String]
    var pattern: String!
    
    init(challengeDetails: NSDictionary) {
        name = challengeDetails["name"] as! String
        attempts = challengeDetails["attempts"] as! NSArray
        description = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as! [String]
        pattern = challengeDetails["pattern"] as! String
        
        print("recieved challenge with name \(name)")
    }
    
    class func challengesFromJSON(challengeArray: NSArray) -> [Challenge] {
        var challenges = [Challenge]()
        
        // loop through JSON to grab all challenges
        for challengeDetails in challengeArray {
            challenges.append(Challenge(challengeDetails: challengeDetails as! NSDictionary))
        }
        
        return challenges
    }
}