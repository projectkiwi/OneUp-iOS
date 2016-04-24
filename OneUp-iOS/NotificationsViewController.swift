////
////  NotificationsViewController.swift
////  OneUp-iOS
////
////  Created by Harris Christiansen on 4/4/16.
////  Copyright © 2016 Kiwi. All rights reserved.
////

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationController?.tabBarItem!.image = UIImage(named: "bell") // Set Tab Bar Icon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        notifications.append(Notification(author: "PURDUEHACKER", statusChange: "liked your challenge", timeStamp: "2 days ago"))
//        notifications.append(Notification(author: "HARRIS", statusChange: "Bookmarked your challenge", timeStamp: "3 days ago"))
//        notifications.append(Notification(author: "ADAM", statusChange: "Liked your attempt", timeStamp: "6 days ago"))
        
        getData()
        
        setupTableView()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 110
    }
    
    func getData() {
        ApiClient.getNotifications { (notifications, error) in
            if error == nil {
                self.notifications = notifications!
                self.tableView.reloadData()
            }
        }
    }
    
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NotificationCell
        
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension NotificationsViewController: UITableViewDelegate {
    
}
