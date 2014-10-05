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
        super.viewDidLoad()
    }
    
    
    @IBAction func signup(sender: AnyObject) {
        
        var username: String = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var password: String = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var email: String = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        

        if username.isEmpty || password.isEmpty || email.isEmpty { // isEmpty is used because length method is not available
            var alertView = UIAlertController(title: "Oops", message: "Make sure you enter a username, password, and email address!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    println("default")
                    
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    println("destructive")
                }
            }))
            self.presentViewController(alertView, animated: true, completion:nil)
            
        } else {
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            newUser.signUpInBackgroundWithBlock({ (succeeded: Bool!, error: NSError!) -> Void in
                
                if error == nil {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    if let info = error.userInfo {
                        var errorString: String = info["error"] as NSString
                        
                        println("the error is: \(errorString)")
                        
                        var alertView = UIAlertController(title: "Sorry", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                            switch action.style{
                            case .Default:
                                println("default")
                                
                            case .Cancel:
                                println("cancel")
                                
                            case .Destructive:
                                println("destructive")
                            }
                        }))
                        self.presentViewController(alertView, animated: true, completion:nil)
                    }
                }
            })
        }
    }
}