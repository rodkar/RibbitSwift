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
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
}