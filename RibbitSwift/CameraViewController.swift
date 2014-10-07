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
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }  else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(imagePicker.sourceType)!
        self.presentViewController(imagePicker, animated: false, completion: nil)
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
        let mediaType = info
//            .indexForKey(UIImagePickerControllerMediaType)
        println("media type is: \(mediaType.indexForKey(UIImagePickerControllerMediaType))")
        
    }

}
