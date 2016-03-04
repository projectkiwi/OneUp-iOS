//
//  Challenge.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import MapKit

class Challenge: NSObject, MKAnnotation {
    
    var name: String!
    var attempts: [Attempt]!
    var desc: String?
    var categories: [String]
    var pattern: String!
    var imgUrl: String!
    var votes: Int!
    let coordinate: CLLocationCoordinate2D
    
    var topAttempt: Attempt!
    
    init(challengeDetails: NSDictionary) {
        name = challengeDetails["name"] as! String
        desc = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as! [String]
        pattern = challengeDetails["pattern"] as! String
        coordinate = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)

        attempts = Attempt.attemptsFromArray(challengeDetails["attempts"] as! NSArray)
        topAttempt = attempts[0]
        votes = topAttempt.voteTotal
        
        imgUrl = topAttempt.imgUrl
        
        
        
//        imgUrl = challengeDetails["imgUrl"] as! String

        
        
        
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