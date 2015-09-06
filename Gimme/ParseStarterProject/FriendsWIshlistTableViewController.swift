//
//  FriendsWishlistViewController
//  Gimme
//
//  Created by Stanislav Gutev on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendsWishlistViewController: UITableViewController {

    var wishlists = [Wishlist]()
    var friend : Friend?
    
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
        
        return cell
    }

    func loadWishlistsForFriend () {
        if friend == nil {
            return
        }
        
        titleLabel?.title = (friend?.name)! + "'s wishlist"
        
        let query = PFQuery(className:"Wishlist")
        query.whereKey("userid", equalTo:(friend?.identifier)!)
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
