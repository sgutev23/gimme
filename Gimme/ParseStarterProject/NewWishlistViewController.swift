//
//  NewWishlistViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class NewWishlistViewController: UIViewController, UITextFieldDelegate {
    
    var isPublic = true {
        didSet {
            privacyDescription.text = isPublic ? PrivacyDescription.Public : PrivacyDescription.Private
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        nameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var privacyDescription: UILabel!
   
    @IBAction func cancel(sender: AnyObject) {
        NSLog("popping")
       performSegueWithIdentifier(SeguesIdentifiers.CancelWishlistSegue, sender: self)
    }
    
    @IBAction func saveNewWishlist(sender: AnyObject) {
    
        var canSaveWishlist = true
        
        if let wishlistName = nameTextField.text {
            if wishlistName.isEmpty {
                canSaveWishlist = false
                addAlert(AlertLabels.NameTitle, message: AlertLabels.NameMessage)
            }
        }
        
        if let wishlistDescription = descriptionTextField.text {
            if wishlistDescription.isEmpty {
                canSaveWishlist = false
                addAlert(AlertLabels.DescriptionTitle, message: AlertLabels.DescriptionMessage)
            }
        }
            
        if canSaveWishlist {
            performSegueWithIdentifier(SeguesIdentifiers.SaveNewWishlistSegue, sender: self)
        }
    }
    
    @IBAction func privacySwitched(sender: UISwitch) {
        isPublic = sender.on
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
    
    private struct PrivacyDescription {
        static let Private = "The wishlist will be private."
        static let Public = "The wishlist will be public."
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
