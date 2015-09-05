//
//  FriendsViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class FriendsViewController: UITableViewController {

    private var friendsMap = [String:Friend]()
    private var friendsArray = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
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
        return friendsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend = friendsArray[indexPath.row]
        cell.nameLabel?.text = friend.name
        cell.wishListCounterLabel?.text = "Wishlists: " + String(friend.numWishLists)
        
        return cell
    }


    func loadFriends() {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let friendObjects = result["data"] as! [NSDictionary]
                var friendIdsArray = [String]()

                for friendObject in friendObjects {
                    let friendId = friendObject["id"] as! String;
                    friendIdsArray.append(friendId)
                }

                let query = PFQuery(className:"_User")
                NSLog("friendsArray \(friendIdsArray)")
                
                query.whereKey("facebookId", containedIn: friendIdsArray)
                query.findObjectsInBackgroundWithBlock {
                    (friendUserids: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        NSLog("friendUserids: \(friendUserids)")
                        if let friendUserids = friendUserids as? [PFObject] {
                            var friendIds = [String]()
                            for friendUserid in friendUserids {
                                let objectId = friendUserid.objectId!
                                friendIds.append(objectId)
                                self.friendsMap[objectId] = Friend(identifier: objectId, name: friendUserid["name"] as! String)
                                self.friendsArray.append(self.friendsMap[objectId]!)
                            }
                            NSLog("friendIds \(friendIds)")
                            self.loadWishlistCounts(friendIds)
                            self.tableView.reloadData()
                        }
                    } else {
                        NSLog("error: \(error)")
                    }

                }
                NSLog("Friends are : \(result)")
            } else {
                NSLog("Error Getting Friends \(error)");
            }
        }
    }

    func loadWishlistCounts(friendsArray: [String]) {
        let query = PFQuery(className:"Wishlist")
        query.whereKey("userid", containedIn: friendsArray)
        query.findObjectsInBackgroundWithBlock {
            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                NSLog("wishlistObjects: \(wishlistObjects)")
                
                if let wishlistObjects = wishlistObjects as? [PFObject] {
                    for wishlistObject in wishlistObjects {
                        var friendId = wishlistObject["userid"] as! String
                        self.friendsMap[friendId]?.numWishLists = (self.friendsMap[friendId]?.numWishLists)! + 1
                    }
                    self.tableView.reloadData()
                } else {
                    NSLog("error: \(error)")
                }
            }
        }

    }
}
