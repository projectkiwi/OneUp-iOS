////
////  NotificationsViewController.swift
////  OneUp-iOS
////
//<<<<<<< HEAD
////  Created by Martynas Kausas on 4/4/16.
//=======
////  Created by Harris Christiansen on 4/4/16.
//>>>>>>> 33e6af5ca7f9eabecc64ecb225f8cac88c7b540d
////  Copyright © 2016 Kiwi. All rights reserved.
////

import UIKit
//<<<<<<< HEAD
import XMSegmentedControl

class NotificationsViewController: UIViewController {

    
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
extension NotificationsViewController: FeedTableViewDelegate {
    func feedTableView(controllerToSwitch: ChallengeDetailViewController) {
        self.navigationController?.pushViewController(controllerToSwitch, animated: true)
    }
}

// data source
extension NotificationsViewController: FeedTableViewDataSource {            
    func feedTableViewChallenges() -> [Challenge] {
        print("grabbing challenges")
        return [Challenge]()
    }
}

extension NotificationsViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int) {
        print("happened")
    }
}
//=======
//
//class NotificationsViewController: UIViewController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupTableView()
//    }
//    
//    func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//    }
//    
//    let notificationItems = ["Notification 1","Notification 2","Notification 3"]
//}
//
//extension NotificationsViewController: UITableViewDataSource {
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return notificationItems.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath)
//        
//        cell.textLabel?.text = notificationItems[indexPath.row]
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        //let cell = tableView.cellForRowAtIndexPath(indexPath)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//}
//
//extension NotificationsViewController: UITableViewDelegate {
//    
//}
//>>>>>>> 33e6af5ca7f9eabecc64ecb225f8cac88c7b540d
