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
            
            //print("Login Response: \(response)")
            
            let responseDict = response as! NSDictionary
            ApiClient.authToken = responseDict["token"] as! String
            MainViewController.userName = responseDict["user"]?["username"] as? String
            var isNewAccount = responseDict["new_account"] as! Bool
            if(MainViewController.userName == nil) { // Require Registration if username is not set
                isNewAccount = true
            }
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
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
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
        
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        var paramsDict: NSDictionary
        
        if params != nil {
            paramsDict = params!
            paramsDict.setValue(ApiClient.authToken, forKey: "token")
        } else {
            paramsDict = ["token":ApiClient.authToken]
        }
        
        http.GET(apiURL+requestPath, parameters: paramsDict, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            //print("Challenges: \(response)")
            
            if let responseDict = response as? NSDictionary {
                if(String(responseDict["message"]) == "Invalid User!") {
                    MainViewController.clearUserInfo()
                    // TODO: Return To Login Screen
                    return
                }
                let challenges = Challenge.challengesFromJSON(responseDict["docs"] as! NSArray)
                completion(challenges: challenges, error: nil)
            } else { // Invalid Response, Kick User Out
                MainViewController.clearUserInfo()
            }

        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error retrieving challenges: \(error.description)")
            completion(challenges: nil, error: error)
        }
    }
    
    /**
        Post Challenge
     */
    class func postChallenge(name:String, desc:String, pattern:String, categories:String, mediaData:NSData, completion: (challengeID: String?, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken, "name":name, "description":desc, "pattern":pattern, "categories":categories]
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.POST(apiURL+"/challenges", parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let responseDict = response as! NSDictionary
            let challengeID = responseDict["data"]?["_id"] as? String
            
            if(challengeID != nil) {
                ApiClient.postAttempt(challengeID!, mediaData: mediaData) { (attemptID, error) -> () in
                    // Do Nothing
                }
            }
            
            completion(challengeID: challengeID, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting challenge: \(error.description)")
            completion(challengeID: nil, error: error)
        }
        
    }
    
    /**
        Post Challenge Attempt
     */
    class func postAttempt(challengeID:String, mediaData:NSData, completion: (attemptID: String?, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken, "description":"iOS - ToDo"]
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.POST(apiURL+"/challenges/"+challengeID+"/attempts/", parameters: params, constructingBodyWithBlock: { (formData) -> Void in
            
            formData.appendPartWithFileData(
                mediaData,
                name: "video",
                fileName: "challenge"+challengeID+String(NSDate().timeIntervalSince1970)+".mp4",
                mimeType: "video/mp4")
            formData.appendPartWithFormData("video".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "video")
            
            }, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                //print("Attempt Creation Response: \(response)")
                let responseDict = response as! NSDictionary
                let attemptID = responseDict["data"]?["_id"] as? String
                completion(attemptID: attemptID, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error posting attempt: \(error.description)")
            completion(attemptID: nil, error: error)
        }
        
    }
    
    /**
        Get Liked Challenges
     */
    
    class func getLiked(completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.GET(apiURL+"/likes/", parameters: nil, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            //print("Likes: \(response)")
            
            if let responseDict = response as? NSDictionary {
                let challenges = Challenge.challengesFromJSON(responseDict["docs"] as! NSArray)
                completion(challenges: challenges, error: nil)
            } else { // Invalid Response, Kick User Out
                MainViewController.clearUserInfo()
            }
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error retrieving likes: \(error.description)")
            completion(challenges: nil, error: error)
        }
    }
    
    /**
        Like Challenge Attempt
     */
    class func likeChallenge(attemptID: String, completion: (liked: Bool, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken]
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.POST(apiURL+"/challenges/like/"+attemptID, parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var liked: Bool? = false
            if let responseDict = response as? NSDictionary {
                liked = responseDict["like"] as? Bool
            }
            completion(liked: liked==true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error liking challenge: \(error.description)")
            completion(liked: false, error: error)
        }
    }
    
    /**
        Get Bookmarks
     */
    
    class func getBookmarks(completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.GET(apiURL+"/bookmarks/", parameters: nil, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            //print("Bookmarks: \(response)")
            
            if let responseDict = response as? NSDictionary {
                let challenges = Challenge.challengesFromJSON(responseDict["docs"] as! NSArray)
                completion(challenges: challenges, error: nil)
            } else { // Invalid Response, Kick User Out
                MainViewController.clearUserInfo()
            }
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error retrieving bookmarks: \(error.description)")
            completion(challenges: nil, error: error)
        }
    }
    
    
    /**
        Bookmark Challenge
     */
    class func bookmarkChallenge(challengeID: String, completion: (bookmarked: Bool, error: NSError?) -> ()) {
        let params:NSDictionary = ["token":ApiClient.authToken]
        http.requestSerializer.setValue(ApiClient.authToken, forHTTPHeaderField: "token")
        
        http.POST(apiURL+"/users/bookmark/"+challengeID, parameters: params, progress: { (progress: NSProgress) -> Void in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var bookmarked: Bool? = false
            if let responseDict = response as? NSDictionary {
                bookmarked = responseDict["bookmark"] as? Bool
            }
            
            completion(bookmarked: bookmarked==true, error: nil)
                    
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Error bookmarking challenge: \(error.description)")
            completion(bookmarked: false, error: error)
        }
    }
    
}