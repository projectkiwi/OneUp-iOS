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

class ChallengeCreationViewController: UIViewController, LocationPickerControllerDelegate {

    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeName: UITextField!
    @IBOutlet weak var challengeDescription: UITextField!
    @IBOutlet weak var patternField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    var videoData: NSData?
    var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChallengeCreationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChallengeCreationViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        print("clicked title")

        if titleSelected == false && self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 216
        }
        
        titleSelected = false
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 216
        }
    }
    
    
    var titleSelected = false
    @IBAction func clickedTitle(sender: AnyObject) {
        titleSelected = true
    }
    
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
        if(videoData == nil) {
            return
        }
        ApiClient.postChallenge(challengeName.text!, desc: challengeDescription.text!, pattern: patternField.text!, categories: categoryField.text!, location: selectedLocation!, mediaData: videoData!) { (challengeID, error) -> () in
            
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

    @IBAction func selectLocation(sender: AnyObject) {
        let lpStoryboard = UIStoryboard(name: "LocationPicker", bundle: nil)
        if let lpController = lpStoryboard.instantiateViewControllerWithIdentifier("LocationPicker") as? LocationPickerController {
            lpController.delegate = self
            self.presentViewController(lpController, animated: true, completion: nil)
        }
    }
    
    func locationPickerController(locationPickerController: LocationPickerController, didSelectLocation location: Location) {
        selectedLocation = location
        locationButton.setTitle("Location: \(location.name)", forState: .Normal)
    }
}

extension ChallengeCreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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