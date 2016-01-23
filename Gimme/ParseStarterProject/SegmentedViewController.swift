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
    
    @IBOutlet weak var wishlistsContainerView: UIView!
    @IBOutlet weak var friendsContainerView: UIView!
    @IBOutlet weak var boughtItemsContainerView: UIView!
    
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
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
            PFUser.logOut()
        }
    }
   
    @IBAction func addWishlist(sender: AnyObject) {
        let wishlist = PFObject(className: DatabaseTables.Wishlist)
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
    
    @IBAction func saveNewWishlist(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let source = segue.sourceViewController as? NewWishlistViewController {
            let wishlist = PFObject(className: DatabaseTables.Wishlist)
            wishlist.setObject(currentUser!, forKey: "user")
            wishlist.setObject(source.nameTextField.text!, forKey: "name")
            wishlist.setObject(source.isPublic, forKey: "public")
            wishlist.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    NSLog("added " + String(wishlist["name"]))
                    self.reloadWishlists()
                } else {
                    NSLog("error adding \(error)")
                }
            }
        }
    }
    
    private func reloadWishlists() -> Void {
        for childViewController in self.childViewControllers {
            if let wishlistsViewController = childViewController as? WishlistViewController {
                wishlistsViewController.loadWishLists()
            }
        }
    }
}
