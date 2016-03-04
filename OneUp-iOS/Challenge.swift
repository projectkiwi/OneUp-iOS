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
    var attempts: NSArray!
    var desc: String?
    var categories: [String]
    var pattern: String!
    var imgUrl: String!
    let coordinate: CLLocationCoordinate2D
    
    init(challengeDetails: NSDictionary) {
        name = challengeDetails["name"] as! String
        attempts = challengeDetails["attempts"] as! NSArray
        desc = challengeDetails["description"] as? String ?? "No Description"
        categories = challengeDetails["categories"] as! [String]
        pattern = challengeDetails["pattern"] as! String
        coordinate = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
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