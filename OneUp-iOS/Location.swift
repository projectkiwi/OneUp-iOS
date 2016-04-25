//
//  Location.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 4/24/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import MapKit

@objc class Location: NSObject {
    
    var id: String
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    let randomLocations: [CLLocationCoordinate2D] = [ CLLocationCoordinate2D(latitude: 42, longitude: -97), CLLocationCoordinate2D(latitude: 44, longitude: -95), CLLocationCoordinate2D(latitude: 41, longitude: -94), CLLocationCoordinate2D(latitude: 40, longitude: -102) ]
    
    init(locationDetails: NSDictionary) {
        id = locationDetails["_id"] as! String
        name = locationDetails["name"] as? String ?? ""
        coordinate = randomLocations[(Int)(arc4random_uniform(4))]
        if let location = locationDetails["location"] as? NSDictionary {
            if let coordinates = location["coordinates"] as? NSArray {
                coordinate = CLLocationCoordinate2D(latitude: coordinates.objectAtIndex(1).doubleValue, longitude: coordinates.objectAtIndex(0).doubleValue)
            }
        }
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