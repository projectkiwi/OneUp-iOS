//
//  ChallengeCreationViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class ChallengeCreationViewController: UIViewController {

    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeName: UITextField!
    @IBOutlet weak var challengeDescription: UITextField!
    @IBOutlet weak var patternField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    
    var videoData: NSData?
    
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
        if(videoData == nil) {
            return
        }
        ApiClient.postChallenge(challengeName.text!, desc: challengeDescription.text!, pattern: patternField.text!, categories: categoryField.text!, mediaData: videoData!) { (challengeID, error) -> () in
            
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
        vc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

extension ChallengeCreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
//        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
//        if mediaType == kUTTypeMovie {
//        }
        
        
        if let referenceURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([referenceURL], options: nil)
            if let phAsset = fetchResult.firstObject as? PHAsset {
                PHImageManager.defaultManager().requestAVAssetForVideo(phAsset, options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
                    if let asset = asset as? AVURLAsset {
                        self.videoData = NSData(contentsOfURL: asset.URL)
                        // optionally, write the video to the temp directory
//                        let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
//                        let videoURL = NSURL(fileURLWithPath: videoPath)
//                        let writeResult = self.videoData?.writeToURL(videoURL, atomically: true)
//                        
//                        if let writeResult = writeResult where writeResult {
//                            print("success")
//                        }
//                        else {
//                            print("failure")
//                        }
                    }
                })
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ChallengeCreationViewController: UINavigationControllerDelegate {
    
}