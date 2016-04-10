//
//  MainViewController.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 2/16/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    static var FBUserID: String?
    static var FBAccessToken: String?
    static var FBEmail: String?
    static var userName: String?
    
    var FBRequestPermissions = ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginButton()
        MainViewController.loadUserInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkAutoLogin()
    }
    
    class func loadUserInfo() {
        MainViewController.FBUserID = NSUserDefaults.standardUserDefaults().stringForKey("FBUserID")
        MainViewController.FBAccessToken = NSUserDefaults.standardUserDefaults().stringForKey("FBAccessToken")
        MainViewController.FBEmail = NSUserDefaults.standardUserDefaults().stringForKey("FBEmail")
        MainViewController.userName = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        let authToken = NSUserDefaults.standardUserDefaults().stringForKey("OneUp_AuthToken")
        if(authToken != nil) {
            ApiClient.authToken = authToken!
        } else {
            ApiClient.authToken = ""
        }
    }
    
    class func saveUserInfo() {
        NSUserDefaults.standardUserDefaults().setObject(MainViewController.FBUserID, forKey: "FBUserID")
        NSUserDefaults.standardUserDefaults().setObject(MainViewController.FBAccessToken, forKey: "FBAccessToken")
        NSUserDefaults.standardUserDefaults().setObject(MainViewController.FBEmail, forKey: "FBEmail")
        NSUserDefaults.standardUserDefaults().setObject(MainViewController.userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setObject(ApiClient.authToken, forKey: "OneUp_AuthToken")
    }
    
    class func clearUserInfo() {
        MainViewController.FBUserID = nil
        MainViewController.FBAccessToken = nil
        MainViewController.FBEmail = nil
        MainViewController.userName = nil
        ApiClient.authToken = ""
        MainViewController.saveUserInfo()
    }
    
    func checkAutoLogin() {
        if(!ApiClient.authToken.isEmpty && MainViewController.userName != nil) {
            enterApplication()
        }
    }
    
    @IBOutlet weak var loginView: FBSDKLoginButton!
    
    func setupLoginButton() {
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            //handle error
        } else {
            processLogin()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func processLogin() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: FBRequestPermissions)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("FB Login Error: \(error)") // Process error
            } else {
                print("Logged In: \(result)")
                MainViewController.FBUserID = result.valueForKey("id") as? String
                MainViewController.FBAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
                MainViewController.FBEmail = result.valueForKey("email") as? String
                
                ApiClient.postLogin() { (registered, error) -> () in // Authenticate with API
                    if error == nil { // success
                        MainViewController.saveUserInfo()
                        if(registered) {
                            self.enterApplication()
                        } else {
                            self.enterRegisterAccount()
                        }
                    }
                }
            }
        })
    }
    
    func enterApplication() {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("MainApp"))! as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    func enterRegisterAccount() {
        let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("RegisterAccount"))! as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

