//
//  AttemptCreationViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class AttemptCreationViewController: UIViewController {

    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    var videoData: NSData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Name: "+ChallengeDetailViewController.challenge.name!)
        challengeNameLabel.text = ChallengeDetailViewController.challenge.name!
    }
    
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
        if(challengeImageView.image == nil) {
            return
        }
        if(videoData != nil) {
            ApiClient.postAttempt(ChallengeDetailViewController.challenge.id!, mediaData: videoData!) { (attemptID, error) -> () in
                if error == nil { // success
                    self.dismissViewControllerAnimated(true,completion: nil);
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectMedia(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
//        vc.sourceType = UIImagePickerControllerSourceType.Camera // use for pics from camera
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

extension AttemptCreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
//        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        if let videoURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            videoData = NSData(contentsOfURL: videoURL)
        }
        
        // Do something with the images (based on your use case)
        challengeImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AttemptCreationViewController: UINavigationControllerDelegate {
    
}