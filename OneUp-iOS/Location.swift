//
//  Location.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 4/24/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation

@objc class Location: NSObject {
    
    var id: String
    var name: String
    
    init(locationDetails: NSDictionary) {
        id = locationDetails["_id"] as! String
        name = locationDetails["name"] as? String ?? ""
    }

    class func locationsFromArray(locationsArray: NSArray) -> [Location] {
        var locations = [Location]()
        
        // loop through JSON to grab all challenges
        for locationDetails in locationsArray {
            locations.append(Location(locationDetails: locationDetails as! NSDictionary))
        }
        
        return locations
    }
}