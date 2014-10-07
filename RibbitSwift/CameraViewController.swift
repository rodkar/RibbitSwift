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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.videoMaximumDuration = 10
        
//        if self.image == nil{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            }  else {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker.sourceType)!
            self.presentViewController(self.imagePicker, animated: false, completion: nil)
//        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
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
            let videoFilePath = imagePickerURL?.path
            if self.imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
                // save the video
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoFilePath){
                    UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, nil, nil, nil)
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
