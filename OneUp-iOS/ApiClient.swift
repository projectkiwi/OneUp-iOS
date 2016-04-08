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
    
    static var fbUserID = ""
    
    /**
        Process FB Login Success w/ API
     */
    
    class func postLogin(fbID:String, completion: (registered: Bool, error: NSError?) -> ()) {
        http.POST(apiURL+"/login/"+fbID, parameters: nil, progress: { (progress: NSProgress) -> Void in },
                  success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let responseDict = response as! NSDictionary
                    responseDict["data"]!["_id"]!?.string
                    let attemptID = responseDict["data"]!["_id"] as? String
                    completion(attemptID: attemptID!, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting attempt: \(error.description)")
            completion(attemptID: nil, error: error)
        }
    }
    
    /**
        Register New Account
     */
    
    
    
    /**
         Retrieves global challenges
     */
    class func getChallenges(requestPath:String, params: NSDictionary?, completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        
        http.GET(apiURL+requestPath, parameters: params, progress: { (progress: NSProgress) -> Void in
            
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
        Post Challenge
     */
    class func postChallenge(name:String, desc:String, pattern:String, categories:String, completion: (challengeID: String?, error: NSError?) -> ()) {
        let params:NSDictionary = ["name":name, "description":desc, "pattern":pattern, "categories":categories]
        
        http.POST(apiURL+"/challenges", parameters: params, progress: { (progress: NSProgress) -> Void in },
                  success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let responseDict = response as! NSDictionary
                    responseDict["data"]!["_id"]!?.string
                    let challengeID = responseDict["data"]!["_id"] as? String
                    http.POST(apiURL+"/challenges/"+challengeID!+"/attempts/", parameters: nil, progress: { (progress: NSProgress) -> Void in },
                        success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                            completion(challengeID: challengeID!, error: nil)
                    }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("Error posting challenge attempt: \(error.description)")
                        completion(challengeID: nil, error: error)
                    }
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting challenge: \(error.description)")
            completion(challengeID: nil, error: error)
        }
        
    }
    
    /**
        Post Challenge Attempt
     */
    class func postAttempt(challengeID:String, attemptImg:UIImage?, completion: (attemptID: String?, error: NSError?) -> ()) {
        http.POST(apiURL+"/challenges/"+challengeID+"/attempts/", parameters: nil, progress: { (progress: NSProgress) -> Void in },
                  success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let responseDict = response as! NSDictionary
                    responseDict["data"]!["_id"]!?.string
                    let attemptID = responseDict["data"]!["_id"] as? String
                    completion(attemptID: attemptID!, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting attempt: \(error.description)")
            completion(attemptID: nil, error: error)
        }
        
    }
    
    /**
        Like Challenge Attempt
     */
    class func likeChallenge(attemptID: String, completion: (liked: Bool, error: NSError?) -> ()) {
        print("Liked: "+attemptID);
        
        http.PATCH(apiURL+"/challenges/like/"+attemptID, parameters: nil,
                   success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    completion(liked: true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error liking challenge: \(error.description)")
            
            completion(liked: false, error: error)
        }
    }
    
    /**
        Bookmark Challenge
     */
    class func bookmarkChallenge(challengeID: String, completion: (bookmarked: Bool, error: NSError?) -> ()) {
        
        http.PATCH(apiURL+"/challenges/bookmark/"+challengeID, parameters: nil, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            completion(bookmarked: true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error liking challenge: \(error.description)")
            
            completion(bookmarked: false, error: error)
        }
    }
    
}