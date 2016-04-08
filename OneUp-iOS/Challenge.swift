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
    
    var id: String!
    var name: String?
    var attempts: [Attempt]!
    var desc: String?
    var categories: [String]?
    var pattern: String?
    var imgUrl: String?
    var votes: Int?
    let coordinate: CLLocationCoordinate2D
    
    var topAttempt: Attempt!
    
    let locations: [CLLocationCoordinate2D] = [ CLLocationCoordinate2D(latitude: 42, longitude: -97), CLLocationCoordinate2D(latitude: 44, longitude: -95), CLLocationCoordinate2D(latitude: 41, longitude: -94), CLLocationCoordinate2D(latitude: 40, longitude: -102) ]
    
    init(challengeDetails: NSDictionary) {
        id = challengeDetails["_id"] as! String
        name = challengeDetails["name"] as? String ?? "No name"
        desc = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as? [String] ?? ["No Catergory"]
        pattern = challengeDetails["pattern"] as? String ?? "No pattern"
        coordinate = locations[(Int)(arc4random_uniform(4))]
        votes = challengeDetails["challenge_likes"] as? Int

        attempts = Attempt.attemptsFromArray(challengeDetails["attempts"] as! NSArray)
        if attempts.count > 0 {
            topAttempt = attempts[0] as Attempt
            imgUrl = topAttempt.imgUrl
        } else {
            imgUrl = "http://fuel-design.com/media/uploads/thumbs/uploads/homepage/This_is_Bad_jpg_321x311_q95.jpg"
        }
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