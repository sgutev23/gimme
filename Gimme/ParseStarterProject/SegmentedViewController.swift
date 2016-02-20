//
//  SegmentedViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import Firebase

class SegmentedViewController: UIViewController {

 //   var user: FAuthData?
 //   var ref: Firebase!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var wishlistsContainerView: UIView!
    @IBOutlet weak var friendsContainerView: UIView!
    @IBOutlet weak var boughtItemsContainerView: UIView!
    
    @IBOutlet weak var addWishlistButton: UIBarButtonItem!
    @IBOutlet weak var navSwitch: UISegmentedControl!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWishlistsContainerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showFriendsContainerView() {
        friendsContainerView.hidden = false
        
        wishlistsContainerView.hidden = true
        boughtItemsContainerView.hidden = true
    }
    
    func showWishlistsContainerView() {
        wishlistsContainerView.hidden = false
        
        friendsContainerView.hidden = true
        boughtItemsContainerView.hidden = true
    }
    
    func showItemsBoughtContainerView() {
        boughtItemsContainerView.hidden = false
        
        friendsContainerView.hidden = true
        wishlistsContainerView.hidden = true
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedController.selectedSegmentIndex
        {
        case 0: showWishlistsContainerView()
        case 1: showFriendsContainerView()
        case 2: showItemsBoughtContainerView()
        default:
            break;
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.LogOutSegue {
            PFUser.logOut()
        } else if segue.identifier == SeguesIdentifiers.NewWishlistSegue {
            
        }
    }
   
    @IBAction func addWishlist(sender: AnyObject) {
        let wishlist = PFObject(className: DatabaseTables.Wishlist)
      //  wishlist["userid"] = currentUser?.objectId
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
    
    @IBAction func unwindAndSave(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let source = segue.sourceViewController as? NewWishlistViewController {
            let uuid = NSUUID().UUIDString
            let wishlist = [
                "userid" : user!.uid,
                "name" : source.nameTextField.text!,
                "public" : source.isPublic
            ]
            
            ref.childByAppendingPath("wishlists")
                .childByAppendingPath(uuid)
                .setValue(wishlist)
        }
    }
    
    @IBAction func unwindAndCancel(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("Cancel")
        
    }
    
    private func reloadWishlists() -> Void {
        for childViewController in self.childViewControllers {
            if let wishlistsViewController = childViewController as? WishlistViewController {
                wishlistsViewController.loadWishLists()
            }
        }
    }
}
