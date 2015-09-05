//
//  SegmentedViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SegmentedViewController: UIViewController {

    let currentUser = PFUser.currentUser()
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var firstContainerView: UIView!
    
    @IBOutlet weak var secondContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstContainerView.hidden = false
        secondContainerView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedController.selectedSegmentIndex
        {
        case 0:
            firstContainerView.hidden = false
            secondContainerView.hidden = true
        case 1:
            firstContainerView.hidden = true
            secondContainerView.hidden = false
        default:
            break;
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.LogOutSegue {
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
            PFUser.logOut()
        }
    }
   
    @IBAction func addWishlist(sender: AnyObject) {
        let wishlist = PFObject(className:"Wishlist")
        wishlist["userid"] = currentUser?.objectId
        wishlist["name"] = "Wishlist " + String(arc4random())
        wishlist.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                NSLog("added " + String(wishlist["name"]))
            } else {
                NSLog("error adding \(error)")
            }
        }
    }
}
