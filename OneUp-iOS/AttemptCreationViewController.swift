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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelSelected(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            print("dismissing from attempt creation cancel")
        }
    }

    @IBAction func onCreateSelected(sender: AnyObject) {
//        ApiClient.postChallenge(challengeName.text!, desc: challengeDescription.text!, pattern: "", categories: "test") { (challengeID, error) -> () in
//            // success
//            if error == nil {
//                self.dismissViewControllerAnimated(true) { () -> Void in
//                    print("dismissing from create attempt")
//                }
//            }
//            // error
//            else {
//                
//            }
//        }
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
        
        // Do something with the images (based on your use case)
        challengeImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AttemptCreationViewController: UINavigationControllerDelegate {
    
}