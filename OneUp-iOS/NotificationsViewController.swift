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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    let notificationItems = ["Notification 1","Notification 2","Notification 3"]
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = notificationItems[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension NotificationsViewController: UITableViewDelegate {
    
}
