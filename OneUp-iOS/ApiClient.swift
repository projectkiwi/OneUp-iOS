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
         
         @param bar Consectetur adipisicing elit.
     */
    class func getChallenges(params: NSDictionary?, completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        
        http.GET(apiURL+"/challenges", parameters: params, progress: { (progress: NSProgress) -> Void in
            
            },
            success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("challenges: \(response)")
                print("Success retrieving challenges!")
                
                let challenges = Challenge.challengesFromJSON(response as! NSArray)
                completion(challenges: challenges, error: nil)
                
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error retrieving challenges: \(error.description)")
                
                completion(challenges: nil, error: error)
        }
    }
}