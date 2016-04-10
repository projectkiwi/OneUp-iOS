//
//  ChallengeCreationViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices

class ChallengeCreationViewController: UIViewController {

    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeName: UITextField!
    @IBOutlet weak var challengeDescription: UITextField!
    @IBOutlet weak var patternField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChallengeCreationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y -= 216
        
        
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 216
    }
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
        ApiClient.postChallenge(challengeName.text!, desc: challengeDescription.text!, pattern: patternField.text!, categories: categoryField.text!, attemptImg: challengeImageView.image!) { (challengeID, error) -> () in
            
            if error == nil { // success
                self.dismissViewControllerAnimated(true,completion: nil)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onSelectMedia(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.mediaTypes = [kUTTypeMovie as NSString as String]

//        vc.sourceType = UIImagePickerControllerSourceType.Camera // use for pics from camera
        vc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

extension ChallengeCreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
//        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        let videoURL = info[UIImagePickerControllerMediaURL] as! NSString
        
        // 2
        dismissViewControllerAnimated(true) {
            // 3
//            if mediaType == kUTTypeMovie {
//                let moviePlayer = MPMoviePlayerViewController(contentURL: info[UIImagePickerControllerMediaURL] as! NSURL)
////                let moviePlayer = AVPlayerViewController()
//                    //)(contentURL: info[UIImagePickerControllerMediaURL] as! NSURL)
//                
//                
//                let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
//                let player = AVPlayer(URL: videoURL)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                self.presentViewController(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
            
                
                
                
//                self.presentMoviePlayerViewControllerAnimated(moviePlayer)
//            }
        }
        
        
        // Do something with the images (based on your use case)
//        challengeImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ChallengeCreationViewController: UINavigationControllerDelegate {
    
}