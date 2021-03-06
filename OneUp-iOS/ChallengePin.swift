//
//  ChallengePin.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import MapKit

class ChallengePin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let challenge: Challenge
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, challenge: Challenge) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.challenge = challenge
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    class func pinsFromChallenges(challengeArray: [Challenge]) -> [ChallengePin] {
        var pins = [ChallengePin]()
        
        // loop through JSON to grab all challenges
        for challenge in challengeArray {
            pins.append(ChallengePin(title: challenge.name, locationName: challenge.locationName, discipline: "Normal", coordinate: challenge.coordinate, challenge: challenge))
        }
        
        return pins
    }
}