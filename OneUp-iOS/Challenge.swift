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
    
    var id: String
    var name: String
    var attempts: [Attempt]
    var desc: String
    var categories: [String]
    var categoriesString: String
    var pattern: String
    var previewGif: String
    var votes: Int
    var likes: Int { get { return votes } }
    var likedTopAttempt: Bool
    var likedPreviousAttempt: Bool
    var isBookmarked: Bool
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var isCached = false
    var cachedGIFImage: UIImage?
    var timestamp: String?
    
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
        
        // Generate Categories String
        categoriesString = ""
        for category in categories {
            categoriesString += "\(category), "
        }
        if categoriesString.characters.count >= 2 {
            categoriesString = categoriesString.substringToIndex(categoriesString.endIndex.predecessor())
            categoriesString = categoriesString.substringToIndex(categoriesString.endIndex.predecessor())
        }
        
        // Get Location
        if let locationDict = challengeDetails["location"] as? NSDictionary {
            let location = Location(locationDetails: locationDict)
            locationName = location.name
            coordinate = location.coordinate
        } else {
            locationName = "Random Location"
            coordinate = randomLocations[(Int)(arc4random_uniform(4))]
        }
        
        // Get Top Attempt
        previewGif = "http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif" // Default - if attempt.count==0
        attempts = Attempt.attemptsFromArray(challengeDetails["attempts"] as! NSArray)
        
        if attempts.count > 0 {
            topAttempt = attempts[attempts.count - 1] as Attempt
            
            previewGif = topAttempt.gifUrl // Get GIF Image
            timestamp = topAttempt.timestamp // Get Timestamp
        }
        
        super.init()
    }
    
    func downloadGIF() {
        if !isCached {
            isCached = true
            if let gif = UIImage.gifWithURL(self.previewGif) {
                // Update Cached GIF
                self.cachedGIFImage = gif
            } else if(self.previewGif != "http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif") {
                 // Download Failed, Try with default GIF
                isCached = false
                self.previewGif = "http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif"
                downloadGIF()
            }
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