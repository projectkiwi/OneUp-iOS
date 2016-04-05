//
//  FilterViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/4/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [String: Bool])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var filterItems: [String: Bool]?
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterItems = ChallengesViewController.filterItems
        setupTableView()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSaveFilter(sender: AnyObject) {
        ChallengesViewController.filterItems = filterItems!
        dismissViewControllerAnimated(true) { () -> Void in
            print("dismissing on save")
            self.delegate?.filtersViewController!(self, didUpdateFilters: self.filterItems!)
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            print("dismissing on cancel")
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
    
    var filterKeys: [String]?

}

extension FilterViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterKeys = Array(filterItems!.keys)
        return filterItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = filterKeys![indexPath.row]
        if filterItems![filterKeys![indexPath.row]] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if cell!.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            filterItems![filterKeys![indexPath.row]] = true
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            filterItems![filterKeys![indexPath.row]] = false
        }
    }
}

extension FilterViewController: UITableViewDelegate {
    
}