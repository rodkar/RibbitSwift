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
    var friends : [PFUser]? // receiving PFUser objects passed from FriendsViewController
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
                
                for user in self.allUsers! {
                    if user.username == PFUser.currentUser().username {
                        if let foundIndex = find(self.allUsers!, user) {
                            //remove the item at the found index
                            self.allUsers!.removeAtIndex(foundIndex)
                        }
                    }
                }
                
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
        
        if isFriend(user)  { // this user is a friend
            // add checkmark
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        } else {
            // clear checkmark
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let row = indexPath.row
        let selectedUser = self.allUsers![row]
        let friendsRelation = currentUser?.relationForKey("friendsRelation")
        
        if isFriend(selectedUser){
            // remove checkmark
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            // remove from the array of friends
            for friend in self.friends! {
                if friend.objectId == selectedUser.objectId {
                    if let foundIndex = find(self.friends!, friend) {
                        //remove the item at the found index
                        self.friends!.removeAtIndex(foundIndex)
                    }
                }
            }
            
            // remove from the backend
            friendsRelation?.removeObject(selectedUser)
            
        } else {
            friendsRelation?.addObject(selectedUser)
            self.friends!.append(selectedUser)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        self.currentUser?.saveInBackgroundWithBlock({ (bool: Bool, error: NSError!) -> Void in
            if error != nil {
                println("error: \(error.userInfo)")
            } else {
                println("relation successfully created!")
            }
        })
    }
    
    // MARK: - helper methods
    
    func isFriend(user : PFUser) -> Bool {
        for friend in self.friends! {
            if friend.objectId == user.objectId {
                return true
            }
        }
        
        return false
    }
    
}