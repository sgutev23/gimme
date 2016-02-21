//
//  FriendsWishlistViewController
//  Gimme
//
//  Created by Stanislav Gutev on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FriendsWishlistViewController: UITableViewController {

    var wishlists = [Wishlist]()
    var friend : User?
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWishlistsForFriend()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendsWishlistCell, forIndexPath: indexPath) as! FriendWishlistTableViewCell
        let wishlist = wishlists[indexPath.row]
        
        cell.nameLabel?.text = wishlist.name
        cell.wishlistId = wishlist.identifier
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.FriendsItemsSegue {
            if let destinationViewController = segue.destinationViewController as? FriendItemsTableViewController {
                if let friendWishlistViewCell = sender as? FriendWishlistTableViewCell {
                    destinationViewController.wishlistId = friendWishlistViewCell.wishlistId
                }
            }
        }
    }

    func loadWishlistsForFriend () {
        if friend == nil {
            return
        }
        
        titleLabel?.title = (friend?.firstName)! + "'s wishlist"
        
//        let query = PFQuery(className:"Wishlist")
//        query.whereKey("userid", equalTo:(friend?.identifier)!)
//        query.whereKey("public", equalTo: true)
//        query.findObjectsInBackgroundWithBlock {
//            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                NSLog("results: \(wishlistObjects)")
//                
//                if let wishlistObjects = wishlistObjects as? [PFObject] {
//                    for wishlistObject in wishlistObjects {
//                        self.wishlists.append(
//                            Wishlist(identifier: wishlistObject.objectId!,
//                                name: wishlistObject["name"] as! String,
//                                description: "desc",
//                                isPublic: true))
//                    }
//                    self.tableView.reloadData()
//                }
//            } else {
//                NSLog("error: \(error)")
//            }
//        }
    }
   
}
