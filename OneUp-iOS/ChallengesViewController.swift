//
//  ChallengesViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import XMSegmentedControl

class ChallengesViewController: UIViewController {

    @IBOutlet weak var feedTableView: FeedTableView!
    
    enum DataSources {
        case Local
        case Popular
        case Global
    }
    
    var currentDataSource:DataSources = .Local
    var challenges = [Challenge]()
    static var filterItems: [String: Bool] = ["sports": true, "Drinks": false, "Food": false]
    var originalChallenges = [Challenge]() // REMOVE AFTER PAGING IMPLEMENTED: dummy data till backend develops paging
    var isMoreDataLoading = false // used for infinate scroll

    override func viewDidLoad() {
        super.viewDidLoad()
        

        feedTableView.feedTableViewDataSource = self
        feedTableView.feedTableViewDelegate = self
        
        currentDataSource = .Local
        setupSegmentedControl()
        loadTableAndData()
        tableViewSetup()
        
        self.navigationController?.tabBarItem!.image = UIImage(named: "home") // Set Tab Bar Icon
    }
    
    
    func setupSegmentedControl() {
        let segmentedControl = XMSegmentedControl(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 44), segmentTitle: ["Local", "Popular", "Global"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor(red: 115/255, green: 44/255, blue: 123/255, alpha: 1)
        segmentedControl.highlightColor = UIColor(red: 165/255, green: 66/255, blue: 220/255, alpha: 1)
        segmentedControl.tint = UIColor.whiteColor()
        segmentedControl.highlightTint = UIColor.lightGrayColor()
        
        self.view.addSubview(segmentedControl)
    }
    
    
    
    // Challenges Table
    func loadTableAndData() {
        // TODO: Apply Filters
        var requestURL = "/challenges/"
        if currentDataSource == .Local {
            requestURL = "/challenges/local/new/"
        } else if currentDataSource == .Popular {
            requestURL = "/challenges/local/popular/"
        } else if currentDataSource == .Global {
            requestURL = "/challenges/"
        }
        
        ApiClient.getChallenges(requestURL,params: nil) { (challenges, error) -> () in
            if error == nil { // success
                self.challenges = challenges!
                self.feedTableView.challenges = challenges!
                self.feedTableView.reloadData()
            }
        }
    }
    
    func tableViewSetup() {
        
        feedTableView.feedTableViewDataSource = self
        feedTableView.feedTableViewDelegate = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destinationViewController = segue.destinationViewController
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveFilter" { // Returning to Home from Filter
            let filterController = segue.sourceViewController as! FilterViewController
            ChallengesViewController.filterItems = filterController.filterItems!
            loadTableAndData(); // Reload Table
        }
    }
}


// delegate
extension ChallengesViewController: FeedTableViewDelegate {
    func feedTableView(controllerToSwitch: ChallengeDetailViewController) {
        self.navigationController?.pushViewController(controllerToSwitch, animated: true)
    }
}

// data source
extension ChallengesViewController: FeedTableViewDataSource {
    func feedTableViewChallenges() -> [Challenge] {
        loadTableAndData()
        return [Challenge]()
    }
}

extension ChallengesViewController: XMSegmentedControlDelegate {
    // XMSegmentedControl
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        if(selectedSegment == 0) {
            currentDataSource = .Local
        }
        if(selectedSegment == 1) {
            currentDataSource = .Popular
        }
        if(selectedSegment == 2) {
            currentDataSource = .Global
        }
        loadTableAndData(); // Reload Table
    }
}