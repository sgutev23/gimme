//
//  NewItemViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MobileCoreServices

class NewItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        
        scrollView.addSubview(imageView)
    }
    
    var imageView = UIImageView()
    var wishlistId: String? = nil
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            resetScrollView()
            scrollView.delegate = self
        }
    }
    
    @IBAction func save(sender: UIButton) {
        var canSaveItem = true
        
        if let itemName = nameLabel.text {
            if itemName.isEmpty {
                canSaveItem = false
                addAlert(AlertLabels.NameTitle, message: AlertLabels.NameMessage)
            }
        }
        
        if canSaveItem {
            performSegueWithIdentifier(SeguesIdentifiers.SaveNewItemSegue, sender: self)
        }
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Add Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                
                self.presentViewController(imageController, animated: true, completion: nil)
            }
            
            alert.addAction(cameraButton)
        } else {
            NSLog("Camera not available")
            
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        imageView.image = image
        imageView.sizeToFit()
        resetScrollView()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetScrollView() {
        scrollView?.contentSize = imageView.frame.size
        
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 1.0
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if(scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    private func addAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: false, completion: nil)
    }
    
    private struct AlertLabels {
        static let NameTitle = "Invalid Name"
        static let DescriptionTitle = "Invalid Description"
        static let NameMessage = "Please enter a valid name."
        static let DescriptionMessage = "Please enter a valid description."
    }
    
}