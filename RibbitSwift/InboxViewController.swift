//
//  InboxViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 9/25/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import Foundation
import UIKit

class InboxViewController: UITableViewController {
    
    override func viewDidLoad() {
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            println("Current user: \(currentUser.email)")
            
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin"{
            println("showLogin seque called")
            let bottomBar = segue.destinationViewController as LoginViewController
            bottomBar.hidesBottomBarWhenPushed = true
            bottomBar.navigationItem.hidesBackButton = true
        }
    }
}