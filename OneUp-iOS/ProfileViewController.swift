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
    @IBOutlet weak var usernameLabel: UILabel!
    
    var me: User?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationController?.tabBarItem!.image = UIImage(named: "profile") // Set Tab Bar Icon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiClient.getSelf { (me, error) in
            if error == nil {
                self.me = me!
            }
        }
        
        setupSegmentedControl()
        feedTableView.feedTableViewDataSource = self
        feedTableView.feedTableViewDelegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        
        usernameLabel.text = MainViewController.userName
    }
    
    @IBAction func logoutClicked(sender: AnyObject) {
        MainViewController.clearUserInfo()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (storyboard.instantiateViewControllerWithIdentifier("LoginHome")) as UIViewController
        self.presentViewController(vc, animated: false, completion: nil)
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
    
    var challenges = [Challenge]()
    func getData(completion: (challenges: [Challenge]?, error: NSError?) -> ()) {
        
        if let ids = me?.bookmarkIDs {
            challenges = [Challenge]()
            for bookmarkID in ids {
                ApiClient.getChallenge(bookmarkID as! String, params: nil, completion: { (challenge, error) in
                    if let challenge = challenge {
                        self.challenges.append(challenge)
                        self.feedTableView.challenges = self.challenges
                        self.feedTableView.reloadData()
                    }
                })
            }
        }
        
//        ApiClient.getChallenges("/challenges/", params: nil) { (challenges, error) -> () in
//            if error == nil { // success
//                self.challenges = challenges!
//                self.feedTableView.challenges = challenges!
//                self.feedTableView.reloadData()
//            }
//        }
    }
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
        getData { (challenges, error) in
            return challenges
        }
    }
}

extension ProfileViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int) {
        print("happened")
    }
}