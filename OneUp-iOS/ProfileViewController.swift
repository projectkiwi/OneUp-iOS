//
//  ProfileViewController.swift
//  
//
//  Created by Martynas Kausas on 4/5/16.
//
//

import UIKit
import XMSegmentedControl

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControlView: XMSegmentedControl!
    @IBOutlet weak var feedTableView: FeedTableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        feedTableView.feedTableViewDataSource = self
        feedTableView.feedTableViewDelegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        getData()
    }
    
    
    func setupSegmentedControl() {
        let segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentedControlView.frame.width, height: 44), segmentTitle: ["challenges", "liked", "watching"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
        segmentedControl3.backgroundColor = UIColor.whiteColor()
        segmentedControl3.highlightColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        segmentedControl3.tint = UIColor(red: 75/255, green: 76/255, blue: 76/255, alpha: 1)
        segmentedControl3.highlightTint = UIColor(red: 75/255, green: 76/255, blue: 76/255, alpha: 1)
        segmentedControl3.edgeHighlightHeight = 2
        segmentedControl3.font = UIFont(name: "AvenirNext-Medium", size: 17)!
        
        segmentedControl3.delegate = self
        segmentedControlView.addSubview(segmentedControl3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var challenges: [Challenge]?
    func getData() {
        ApiClient.getChallenges("/challenges/", params: nil) { (challenges, error) -> () in
            // success
            if error == nil {
                self.challenges = challenges!
                self.feedTableView.challenges = challenges!
                self.feedTableView.reloadData()
            }
                
                // error
            else {
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// delegate
extension ProfileViewController: FeedTableViewDelegate {
    func feedTableView(controllerToSwitch: ChallengeDetailViewController) {
        self.navigationController?.pushViewController(controllerToSwitch, animated: true)
    }
}

// data source
extension ProfileViewController: FeedTableViewDataSource {
    func feedTableViewChallenges() -> [Challenge] {
        print("grabbing challenges")
        return [Challenge]()
    }
}

extension ProfileViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int) {
        print("happened")
    }
}