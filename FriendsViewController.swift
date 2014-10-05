//
//  FriendsViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 5/10/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    
    var allFriends : [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        
        let query = friendsRelation.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.allFriends = objects as? [PFUser]
                self.tableView.reloadData()
            } else {
                println("Error: \(error.userInfo)")
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.allFriends?.count {
            return (count)
        } else {
            //allUsers is nil, so just return 0
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let friend = self.allFriends![row]
        cell.textLabel?.text = friend.username
        
        return cell
    }
}
