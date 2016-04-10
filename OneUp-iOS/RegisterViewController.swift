//
//  RegisterViewController.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 4/10/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setUsernameClicked(sender: AnyObject) {
        if let username = usernameField.text {
            if(!username.isEmpty) {
                registerUsername(username)
            }
        }
    }
    
    func registerUsername(username: String) {
        saveUsername(username)
        
        ApiClient.postRegister() { (registered, error) -> () in // Register Username
            if error == nil { // success
                self.enterApplication()
            }
        }
    }
    
    func saveUsername(username: String) {
        MainViewController.userName = username
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "userName")
    }
    
    func enterApplication() {
        //let storyboard = UIStoryboard(name: "MyStoryboardName", bundle: nil)
        let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("MainApp"))! as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
}
