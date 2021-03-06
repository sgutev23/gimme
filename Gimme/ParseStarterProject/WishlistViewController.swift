//
//  WishlistViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 1/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

class WishlistViewController: UITableViewController {
   
//    var user: FAuthData?
  //  var ref: Firebase!
    
    private var wishlists = [Wishlist]()
    private var currentSelectedWishlist: Wishlist? = nil
    
    // MARK: View Controller Lifecycle
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.ItemsViewSegue {
            if let destinationViewController = segue.destinationViewController as? ItemsTableViewController {
                if let wishListItemViewCell = sender as? WishlistItemTableViewCell {
                    if let wishlist = wishListItemViewCell.wishlist {
                        destinationViewController.wishlist = wishlist
                    }
                }
            }
        }
    }

    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.WishlistItemCell, forIndexPath: indexPath) as! WishlistItemTableViewCell
        let wishlist = wishlists[indexPath.row]
        
        cell.nameLabel?.text = wishlist.name
        
        if(!wishlist.isPublic) {
            cell.nameLabel?.font = UIFont.italicSystemFontOfSize((cell.nameLabel?.font.pointSize)!)
        }
        
        cell.wishlist = wishlist
        if (indexPath.row % 3 == 1) {
            cell.categoryImage.image = UIImage(named: "gift")
        } else if (indexPath.row % 3 == 2) {
            cell.categoryImage.image = UIImage(named: "xmas")
        } else {
            cell.categoryImage.image = UIImage(named: "heart")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            self.deleteWishlist(indexPath.item)
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func loadWishLists() {
        
        ref.childByAppendingPath("wishlists")
            .queryOrderedByChild("userid")
            .queryEqualToValue(currentUser!.identifier)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    NSLog("error")
                } else {
                    self.wishlists.removeAll()
                    let enumerator = snapshot.children
                    while let single = enumerator.nextObject() as? FDataSnapshot {
                        let name = single.value.objectForKey("name") as! String;
                        let isPublic = single.value.objectForKey("public") as! Bool
                        let uid = single.key
                        NSLog ("\(single)")
                        self.wishlists.append(
                            Wishlist(
                                identifier: uid,
                                name: name,
                                description: "desc",
                                isPublic: isPublic)
                        )
                    }
                    self.tableView.reloadData()
                }
        })
    }
    
    func deleteWishlist(wishlistIndex: Int) {
    //    let wishlistToDelete = self.wishlists[wishlistIndex]
        
//        let query = PFQuery(className: DatabaseTables.Wishlist)
//        query.whereKey("objectId", equalTo: wishlistToDelete.identifier)
//        query.findObjectsInBackgroundWithBlock {
//            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                if let wishlistObjects = wishlistObjects as? [PFObject] {
//                    for wishlistObject in wishlistObjects {
//                        NSLog("Deleting wishlist with id: \(wishlistObject.objectId)")
//                        wishlistObject.deleteInBackground()
//                    }
//                }
//            } else {
//                NSLog("error: \(error)")
//            }
  //      }
        
    //    self.wishlists.removeAtIndex(wishlistIndex)
    //    self.tableView.reloadData()
    }
}
