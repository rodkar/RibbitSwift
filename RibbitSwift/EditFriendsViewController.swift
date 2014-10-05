//
//  EditFriendsViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 9/26/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import Foundation
import UIKit

class EditFriendsViewController: UITableViewController{
    
    var allUsers : [PFUser]?
    let currentUser = PFUser.currentUser()?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                self.allUsers = objects as? [PFUser]
                
                println("Successfully retrieved \(self.allUsers!.count) users.")
                
                self.tableView.reloadData()
                
            } else {
                println("Error: \(error.userInfo)")
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.allUsers?.count {
            return (count)
        } else {
            //allUsers is nil, so just return 0
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let user = self.allUsers![row]
        cell.textLabel?.text = user.username
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        let friendsRelation = currentUser?.relationForKey("friendsRelation")
        let row = indexPath.row
        let selectedUser = self.allUsers![row] // user selected
        friendsRelation?.addObject(selectedUser)
        
        self.currentUser?.saveInBackgroundWithBlock({ (bool: Bool, error: NSError!) -> Void in
            if error != nil {
                println("error: \(error.userInfo)")
            } else {
                println("relation successfully created!")
            }
        })
    }
}