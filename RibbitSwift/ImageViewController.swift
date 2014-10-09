//
//  ImageViewController.swift
//  RibbitSwift
//
//  Created by Kar Roderick Sze Hsing on 10/9/14.
//  Copyright (c) 2014 Cloudyun. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var message : PFObject?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageFile = self.message!["file"] as PFFile
        let imageFileUrl = NSURL(string: imageFile.url)
        let imageData = NSData.dataWithContentsOfURL(imageFileUrl, options: nil, error: nil)
        self.imageView.image = UIImage(data: imageData)

        let senderName = self.message!["senderName"] as String
        let title = "Sent from \(senderName)"
        self.navigationItem.title = title
    }
    
}
