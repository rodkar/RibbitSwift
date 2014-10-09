//
//  CameraViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 10/6/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import UIKit
import MobileCoreServices


class CameraViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var image : UIImage?
    var videoFilePath : String?
    var friends : [PFUser]?
    var recipients = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        if self.image == nil && self.videoFilePath == nil {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.videoMaximumDuration = 10
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            }  else {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker.sourceType)!
            self.presentViewController(self.imagePicker, animated: false, completion: nil)
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        let user = self.friends![indexPath.row] as PFUser
        
        
        if cell.accessoryType == UITableViewCellAccessoryType.None {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            self.recipients.append(user.objectId)
            
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            // remove from the array of friends
            
            if let foundIndex = find(self.recipients, user.objectId) {
                //remove the item at the found index
                self.recipients.removeAtIndex(foundIndex)
            }
        }
        
        println(recipients)
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
        
        if let foundIndex = find(self.recipients, friend.objectId) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    // MARK: - Image Picker Controller Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        if mediaType == kUTTypeImage {
            // a photo was taken/selected!
            self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if self.imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
                // save the image
                UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
            }
            
        } else {
            // a video was taken/selected
            let imagePickerURL = info[UIImagePickerControllerMediaURL] as? NSURL
            self.videoFilePath = imagePickerURL?.path
            
            if self.imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
                // save the video
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath){
                    UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil)
                }
            }
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func cancel(sender: AnyObject) {
        self.reset()
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func send(sender: AnyObject) {
        if self.image == nil && self.videoFilePath == nil{
            let alertView = UIAlertController(title: "Try again!", message: "Please capture or select a photo or video to share!", preferredStyle: UIAlertControllerStyle.Alert)
            
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
            self.presentViewController(self.imagePicker, animated: false, completion: nil)
        } else {
            self.uploadMessage()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    // MARK: - Helper methods
    
    func reset() {
        self.image = nil
        self.videoFilePath = nil
        self.recipients.removeAll(keepCapacity: false)
    }
    
    func uploadMessage() {
        
        var fileData : NSData?
        var fileName : String?
        var fileType : String?
        
        if self.image != nil {
            let newImage = self.resizeImage(self.image!, width: 320, height: 480)
            fileData = UIImagePNGRepresentation(newImage)
            fileName = "image.png"
            fileType = "image"
        } else {
            fileData = NSData.dataWithContentsOfFile(self.videoFilePath!, options: nil, error: nil)
            fileName = "video.mov"
            fileType = "video"
        }
        
        let file = PFFile(name: fileName, data: fileData)
        
        var message = PFObject(className: "Messages")
        
        file.saveInBackgroundWithBlock { (succeeded:Bool, NSError:NSError!) -> Void in
            
            if NSError != nil {
                let alertView = UIAlertController(title: "An error occurred!", message: "Please try sending your message again.", preferredStyle: UIAlertControllerStyle.Alert)
                
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
                message["file"] = file
                message["fileType"] = fileType
                message["recipientIds"] = self.recipients
                message["senderId"] = PFUser.currentUser().objectId
                message["senderName"] = PFUser.currentUser().username
                message.save()
                self.reset()
            }
        }
        
//        message.saveInBackgroundWithBlock { (succeeded : Bool, error : NSError!) -> Void in
//            if error != nil {
//                let alertView = UIAlertController(title: "An error occurred!", message: "Please try sending your message again.", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
//                    switch action.style{
//                    case .Default:
//                        println("default")
//                        
//                    case .Cancel:
//                        println("cancel")
//                        
//                    case .Destructive:
//                        println("destructive")
//                    }
//                }))
//                self.presentViewController(alertView, animated: true, completion:nil)
//                
//            } else {
//                // everything was successful
//                self.reset()
//            }
//        }
    }
    
    func resizeImage(image : UIImage, width : CGFloat, height : CGFloat ) -> UIImage {
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        self.image?.drawInRect(newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}