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
    
    static var authToken: String = ""
    
    /**
        Process FB Login Success w/ API
     */
    
    class func postLogin(completion: (registered: Bool, error: NSError?) -> ()) {
        let params:NSDictionary = ["facebook_id":MainViewController.FBUserID!, "access_token":MainViewController.FBAccessToken!,"email":MainViewController.FBEmail!]
        
        http.POST(apiURL+"/auth/facebook", parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print("Login Response: \(response)")
            
            let responseDict = response as! NSDictionary
            ApiClient.authToken = responseDict["token"] as! String
            MainViewController.userName = responseDict["username"] as? String // TODO: Not reading as string from NSDictionary
            let isNewAccount = responseDict["new_account"] as! Bool
            completion(registered: !isNewAccount, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error on login: \(error.description)")
            completion(registered: false, error: error)
        }
    }
    
    /**
        Register New Account
     */
    
    class func postRegister(completion: (success: Bool, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken, "facebook_id":MainViewController.FBUserID!, "access_token":MainViewController.FBAccessToken!, "email":MainViewController.FBEmail!,"username":MainViewController.userName!]
        
        http.PUT(apiURL+"/me", parameters: params, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            //let responseDict = response as! NSDictionary
            //let attemptID = responseDict["data"]!["_id"] as? String
            completion(success: true, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error on register: \(error.description)")
            completion(success: false, error: error)
        }
    }
    
    /**
         Retrieves challenges (use requestPath to specify local/popular/global)
     */
    class func getChallenges(requestPath:String, params: NSDictionary?, completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        
        var paramsDict: NSDictionary
        
        if params != nil {
            paramsDict = params!
            paramsDict.setValue(ApiClient.authToken, forKey: "token")
        } else {
            paramsDict = ["token":ApiClient.authToken]
        }
        
        http.GET(apiURL+requestPath, parameters: paramsDict, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            //print("Challenges: \(response)")
            
            let docs = response as! NSDictionary
            if(docs["message"] != nil) { // Message set (ex: Invalid User!)
                // TODO: Logout
                return
            }
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
    class func postChallenge(name:String, desc:String, pattern:String, categories:String, mediaFile:String, completion: (challengeID: String?, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken, "name":name, "description":desc, "pattern":pattern, "categories":categories]
        
        http.POST(apiURL+"/challenges", parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let responseDict = response as! NSDictionary
            let challengeID = responseDict["data"]!["_id"] as? String
            
            if(challengeID != nil) {
                ApiClient.postAttempt(challengeID!, mediaFile: mediaFile) { (attemptID, error) -> () in
                    // Do Nothing
                }
            }
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting challenge: \(error.description)")
            completion(challengeID: nil, error: error)
        }
        
    }
    
    /**
        Post Challenge Attempt
     */
    class func postAttempt(challengeID:String, mediaFile:String, completion: (attemptID: String?, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken, "description":"iOS - ToDo", "video":"todo"]
        //let imageData = UIImageJPEGRepresentation(attemptImg, 0.3)
        let mediaData = NSData(contentsOfFile: mediaFile)
        
        http.POST(apiURL+"/challenges/"+challengeID+"/attempts/", parameters: params, constructingBodyWithBlock: { (formData) -> Void in
            
            formData.appendPartWithFileData(
                mediaData!,
                name: "video",
                fileName: "challenge"+challengeID+String(NSDate().timeIntervalSince1970),
                mimeType: "image/jpeg")
            formData.appendPartWithFormData("video".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, name: "video")
            
            }, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
                let responseDict = response as! NSDictionary
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
        let params:NSDictionary = ["token":ApiClient.authToken]
        
        http.POST(apiURL+"/challenges/like/"+attemptID, parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
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
        let params:NSDictionary = ["token":ApiClient.authToken]
        
        http.PATCH(apiURL+"/challenges/bookmark/"+challengeID, parameters: params, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            completion(bookmarked: true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error liking challenge: \(error.description)")
            
            completion(bookmarked: false, error: error)
        }
    }
    
}