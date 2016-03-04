//
//  FilterViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/4/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var filterItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterItems.append("Sports")
        filterItems.append("Drinks")
        filterItems.append("Food")
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    
}