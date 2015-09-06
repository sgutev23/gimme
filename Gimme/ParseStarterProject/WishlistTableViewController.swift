//
//  WishlistTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class WishlistTableViewController: UITableViewController {
    
    private var currentUser = PFUser.currentUser()
    private var wishlists = [Wishlist]()
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.LogOutSegue {
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
            PFUser.logOut()
        }
        if segue.identifier == SeguesIdentifiers.ItemsViewSegue {
            if let destinationViewController = segue.destinationViewController as? ItemsTableViewController {
                if let wishlistTableViewCell = sender as? WishlistTableViewCell {
                    if let wishlistId = wishlistTableViewCell.wishlistId {
                        //TODO search items for wishlistID
                        NSLog("\(wishlistId)")
                        destinationViewController.items = StaticData.Items
                    }
                }
            }
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        NSLog("logging out")
        PFUser.logOut()
    }
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWishLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlists.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.WishlistCell, forIndexPath: indexPath) as! WishlistTableViewCell
        
        let wishlist = wishlists[indexPath.row]
        cell.nameLabel?.text = wishlist.name
        cell.descriptionLabel?.text = wishlist.description
        cell.wishlistId = wishlist.identifier

        return cell
    }

    func loadWishLists() {
        let query = PFQuery(className:"Wishlist")
        query.whereKey("userid", equalTo:currentUser!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                NSLog("results: \(wishlistObjects)")
                
                if let wishlistObjects = wishlistObjects as? [PFObject] {
                    for wishlistObject in wishlistObjects {
                        self.wishlists.append(
                            Wishlist(identifier: wishlistObject.objectId!,
                                name: wishlistObject["name"] as! String,
                                description: "desc"))
                    }
                    self.tableView.reloadData()
                }
            } else {
                NSLog("error: \(error)")
            }
        }

    }
}
