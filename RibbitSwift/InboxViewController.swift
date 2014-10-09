//
//  InboxViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 9/25/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class InboxViewController: UITableViewController {
    
    var messages : [PFObject]?
    var selectedMessage : PFObject?
    var moviePlayer : MPMoviePlayerController?
    
    override func viewDidLoad() {
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            println("Current user: \(currentUser.email)")
            
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var query = PFQuery(className:"Messages")
        query.whereKey("recipientIds", equalTo:PFUser.currentUser().objectId)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) messages.")
                
                self.messages = objects as? [PFObject]
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.messages?.count {
            return (count)
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let message = self.messages![indexPath.row]
        cell.textLabel?.text = message["senderName"] as? String
        
        let fileType = message["fileType"] as? String
        
        if fileType == "image" {
            cell.imageView?.image = UIImage(named: "icon_image")
        } else {
            cell.imageView?.image = UIImage(named: "icon_video")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedMessage = self.messages![indexPath.row]
        
        let fileType = self.selectedMessage!["fileType"] as? String
        
        if fileType == "image" {
            self.performSegueWithIdentifier("showImage", sender: self)
        } else {
            let videoFile = self.selectedMessage!["file"] as PFFile
            let fileUrl = NSURL(string:videoFile.url)
            self.moviePlayer?.contentURL = fileUrl
            self.moviePlayer?.prepareToPlay()
            
            // add it to the view controller so we can see it
            let moviePlayerView : UIView = self.moviePlayer!.view!
            
            self.view.addSubview(moviePlayerView)
            self.moviePlayer?.setFullscreen(true, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin"{
            println("showLogin seque called")
            let bottomBar = segue.destinationViewController as LoginViewController
            bottomBar.hidesBottomBarWhenPushed = true
            bottomBar.navigationItem.hidesBackButton = true
        } else if segue.identifier == "showImage" {
            let imageViewController = segue.destinationViewController as ImageViewController
            imageViewController.hidesBottomBarWhenPushed = true
            imageViewController.message = self.selectedMessage! as PFObject
        }
    }
    
}
