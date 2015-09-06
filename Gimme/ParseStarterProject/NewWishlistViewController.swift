//
//  NewWishlistViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class NewWishlistViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
   
    @IBAction func saveNewWishlist(sender: UIButton) {
        if let wishlistName = nameTextField.text {
            if !wishlistName.isEmpty {
                performSegueWithIdentifier(SeguesIdentifiers.SaveNewWishlistSegue, sender: self)
            } else {
                addAlert(AlertLabels.NameTitle, message: AlertLabels.NameMessage)
            }
        } else if let wishlistDescription = descriptionTextField.text {
            if !wishlistDescription.isEmpty {
                performSegueWithIdentifier(SeguesIdentifiers.SaveNewWishlistSegue, sender: self)
            } else {
                addAlert(AlertLabels.DescriptionTitle, message: AlertLabels.DescriptionMessage)
            }
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
        static let DescriptionMessage = "Please enter a valid description"
    }
}
