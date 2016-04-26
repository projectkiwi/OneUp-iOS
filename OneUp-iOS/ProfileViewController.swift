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
    var ids = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationController?.tabBarItem!.image = UIImage(named: "profile") // Set Tab Bar Icon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiClient.getSelf { (me, error) in
            if error == nil {
                self.me = me!
                
                self.profileImageView.setImageWithURL(NSURL(string: (me?.avatarImgUrl!)!)!)
                self.ids = me?.associatedIds as! [String]
                
                self.getData()
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
        let segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentedControlView.frame.width, height: 44), segmentTitle: ["challenges", "liked", "bookmarked"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
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
    func getData() {
        ApiClient.getChallengeBatch(ids, params: nil, completion: { (challenges, error) in
            if error == nil {
                self.challenges = challenges!
                self.feedTableView.challenges = challenges!
                self.feedTableView.reloadData()
            }
        })            

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
        getData()
        return [Challenge]()
    }
}

extension ProfileViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int) {
        switch selectedSegment {
        case 0:
            ids = me?.associatedIds as! [String]
            break
            
        case 1:
            ids = me?.likedIDs as! [String]
            break
            
        case 2:
            ids = me?.bookmarkIDs as! [String]
            break
            
        default:
            ids = me?.associatedIds as! [String]

        }
        getData()
        
    }
}