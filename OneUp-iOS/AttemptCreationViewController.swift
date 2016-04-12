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

    @IBOutlet weak var challengeImageView: UIImageView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    var videoData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Name: "+ChallengeDetailViewController.challenge.name)
        challengeNameLabel.text = ChallengeDetailViewController.challenge.name
    }
    
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
        if(videoData == nil) {
            return
        }
        ApiClient.postAttempt(ChallengeDetailViewController.challenge.id, mediaData: videoData!) { (attemptID, error) -> () in
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