//
//  AttemptCreationViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class AttemptCreationViewController: UIViewController {

    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var descriptionInput: UITextField!
    
    var videoData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Name: "+ChallengeDetailViewController.challenge.name)
        challengeNameLabel.text = ChallengeDetailViewController.challenge.name
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChallengeCreationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 216
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 216
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
        if(videoData == nil) {
            return
        }
        ApiClient.postAttempt(ChallengeDetailViewController.challenge.id, description: descriptionInput.text!, mediaData: videoData!) { (attemptID, error) -> () in
            if error == nil { // success
                self.dismissViewControllerAnimated(true,completion: nil);
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
        vc.mediaTypes = [kUTTypeMovie as NSString as String]
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

extension AttemptCreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let referenceURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([referenceURL], options: nil)
            if let phAsset = fetchResult.firstObject as? PHAsset {
                PHImageManager.defaultManager().requestAVAssetForVideo(phAsset, options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
                    if let asset = asset as? AVURLAsset {
                        self.videoData = NSData(contentsOfURL: asset.URL)
                    }
                })
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AttemptCreationViewController: UINavigationControllerDelegate {
    
}