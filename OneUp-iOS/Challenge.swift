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
    
    let locations: [CLLocationCoordinate2D] = [ CLLocationCoordinate2D(latitude: 42, longitude: -97), CLLocationCoordinate2D(latitude: 44, longitude: -95), CLLocationCoordinate2D(latitude: 41, longitude: -94), CLLocationCoordinate2D(latitude: 40, longitude: -102) ]
    
    init(challengeDetails: NSDictionary) {
        name = challengeDetails["name"] as! String
        desc = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as! [String]
        pattern = challengeDetails["pattern"] as! String
        coordinate = locations[(Int)(arc4random_uniform(4))]

        attempts = Attempt.attemptsFromArray(challengeDetails["attempts"] as! NSArray)
        topAttempt = attempts[0]
        votes = topAttempt.voteTotal
        imgUrl = topAttempt.imgUrl
        
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