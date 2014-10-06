//
//  FriendsViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 5/10/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
    
    var friends : [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        
        let query = friendsRelation.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.friends = objects as? [PFUser]
                
                for friend in self.friends! {
                    if friend.username == PFUser.currentUser().username {
                        if let foundIndex = find(self.friends!, friend) {
                            //remove the item at the found index
                            self.friends!.removeAtIndex(foundIndex)
                        }
                    }
                }
                self.tableView.reloadData()
            } else {
                println("Error: \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditFriends" {
            var viewController = segue.destinationViewController as EditFriendsViewController
            viewController.friends = self.friends
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.friends?.count {
            return (count)
        } else {
            //allUsers is nil, so just return 0
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let friend = self.friends![row]
        
        cell.textLabel?.text = friend.username
        return cell
    }
}
