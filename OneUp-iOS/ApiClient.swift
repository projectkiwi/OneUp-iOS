//
//  ApiClient.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import AFNetworking

class ApiClient: AFHTTPSessionManager {
    
    static let http = AFHTTPSessionManager()
    static var apiURL = "http://kiwiapi.purduecs.com"
    
    
    /**
         Retrieves global challenges
     */
    class func getChallenges(params: NSDictionary?, completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        
        http.GET(apiURL+"/challenges", parameters: params, progress: { (progress: NSProgress) -> Void in
            
            },
            success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Challenges: \(response)")
                //print("Success retrieving challenges!")
                
                
                let docs = response as! NSDictionary
                let challenges = Challenge.challengesFromJSON(docs["docs"] as! NSArray)
                completion(challenges: challenges, error: nil)
                
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error retrieving challenges: \(error.description)")
                
                completion(challenges: nil, error: error)
        }
    }
    
    /**
        Like Challenge Attempt
    */
    class func likeChallenge(attemptID: String, completion: (liked: Bool?, error: NSError?) -> ()) {
        print("Liked: "+attemptID);
        
        http.GET(apiURL+"/challenges/like/"+attemptID, parameters: nil, progress: { (progress: NSProgress) -> Void in },
                 success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    
                    completion(liked: true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error liking challenge: \(error.description)")
            
            completion(liked: nil, error: error)
        }
    }
}