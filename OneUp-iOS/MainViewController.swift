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
    
    static var userID: String?
    static var FBAccessToken: String?
    static var FBEmail: String?
    static var userName: String?
    
    var FBRequestPermissions = ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginButton()
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
                MainViewController.userID = result.valueForKey("id") as? String
                MainViewController.FBAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
                MainViewController.FBEmail = result.valueForKey("email") as? String
                MainViewController.userName = "NameToDo"
                
                ApiClient.postLogin() { (registered, error) -> () in // Authenticate with API
                    if error == nil { // success
                        self.enterApplication()
                    }
                }
            }
        })
    }
    
    @IBAction func skipLoginClicked(sender: AnyObject) {
        enterApplication()
    }
    
    func enterApplication() {
        //let storyboard = UIStoryboard(name: "MyStoryboardName", bundle: nil)
        let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("MainApp"))! as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

