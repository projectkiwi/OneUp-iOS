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
    var name: String!
    var attempts: [Attempt]!
    var desc: String!
    var categories: [String]!
    var pattern: String!
    var imgUrl: String!
    var votes: Int!
    var likes: Int! { get { return votes } }
    var likedTopAttempt: Bool!
    var likedPreviousAttempt: Bool!
    var isBookmarked: Bool!
    let coordinate: CLLocationCoordinate2D
    var username: String?
    var recordHolders: NSArray?
    var currentRecord: NSDictionary?
    
    var topAttempt: Attempt!
    
    let randomLocations: [CLLocationCoordinate2D] = [ CLLocationCoordinate2D(latitude: 42, longitude: -97), CLLocationCoordinate2D(latitude: 44, longitude: -95), CLLocationCoordinate2D(latitude: 41, longitude: -94), CLLocationCoordinate2D(latitude: 40, longitude: -102) ]
    
    init(challengeDetails: NSDictionary) {
        id = challengeDetails["_id"] as! String
        name = challengeDetails["name"] as? String ?? "No name"
        desc = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as? [String] ?? ["No Catergories"]
        pattern = challengeDetails["pattern"] as? String ?? "No pattern"
        votes = challengeDetails["challenge_likes"] as? Int ?? 0
        likedTopAttempt = challengeDetails["liked_top_attempt"] as? Bool ?? false
        likedPreviousAttempt = challengeDetails["liked_previous_attempt"] as? Bool ?? false
        isBookmarked = challengeDetails["bookmarked_challenge"] as? Bool ?? false
        
        // Get Location
        let challengeLoc = challengeDetails["location"] as? NSArray
        if(challengeLoc != nil) {
            coordinate = CLLocationCoordinate2D(latitude: challengeLoc!.objectAtIndex(0).doubleValue, longitude: challengeLoc!.objectAtIndex(1).doubleValue)
        } else {
            coordinate = randomLocations[(Int)(arc4random_uniform(4))]
        }
        
        // Get Top Record Holder Name
        if let recordHolders = challengeDetails["record_holders"] as? NSArray {
            if recordHolders.count > 0 {
                currentRecord = recordHolders[0] as? NSDictionary
                username = currentRecord!["username"] as? String
            }
        }
        
        // Get Top Attempt - For Image
        imgUrl = "iosNoAttemptImg.jpg"
        attempts = Attempt.attemptsFromArray(challengeDetails["attempts"] as! NSArray)
        if attempts.count > 0 {
            topAttempt = attempts[attempts.count - 1] as Attempt
            imgUrl = topAttempt.imgUrl
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