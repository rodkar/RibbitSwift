//
//  SignupViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 9/26/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        viewDidLoad()
    }
    
    @IBAction func signup(sender: AnyObject) {
        var username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
    }
    
}