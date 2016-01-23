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

    private var friends = [Friend]()
    
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
        return friends.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendCell, forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend = friends[indexPath.row]
        cell.friend = friend
        cell.nameLabel?.text = "\(friend.firstName) \(friend.lastName)"
        cell.wishListCounterLabel?.text = "WISHLISTS: " + String(friend.numWishLists)
        cell.profilePic.image = friend.profilePic
        cell.profilePic.clipsToBounds = true;
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
        cell.profilePic.layer.borderWidth = 1.0;
        let borderColor : UIColor = UIColor.lightGrayColor()
        cell.profilePic.layer.borderColor = borderColor.CGColor;
        
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
                        if let friendUserids = friendUserids as? [PFObject] {
                            for friendUserid in friendUserids {
                                let objectId = friendUserid.objectId!
                                
                                if let profilePictureFile = friendUserid["profilePicture"] as? PFFile {
                                    profilePictureFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                                        var profilePicture: UIImage? = nil
                                        
                                        if error == nil {
                                            profilePicture = UIImage(data: imageData!)
                                        } else {
                                            NSLog("Error retrieving profile pic data for user \(objectId): \(error?.localizedDescription).")
                                        }
                                        
                                        let friend = Friend(
                                            identifier: objectId,
                                            firstName: friendUserid["firstName"] as! String,
                                            lastName: friendUserid["lastName"] as! String,
                                            profilePic: profilePicture)
                                        self.friends.append(friend)
                                        self.loadWishlistCount(friend)
                                    }
                                }
                            }
                            
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
    
    func loadWishlistCount(friend: Friend) {
        let query = PFQuery(className: DatabaseTables.Wishlist)
        query.whereKey("userid", equalTo: friend.identifier)
        query.whereKey("public", equalTo: true)
        
        query.countObjectsInBackgroundWithBlock {
            (count, error) -> Void in
            
            if error == nil {
                NSLog("NUMBER OF WISHLISTS for \(friend.identifier): \(count)")
                friend.numWishLists = Int(count)
                self.tableView.reloadData()
            } else {
                NSLog("Error getting the number of wishlists for friend \(friend.identifier): \(error?.localizedDescription)")
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.FriendsWishlistSegue {
            if let destinationViewController = segue.destinationViewController as? FriendsWishlistViewController {
                if let friendTableViewCell = sender as? FriendTableViewCell {
                    if let friend = friendTableViewCell.friend {
                        destinationViewController.friend = friend
                    }
                }
            }
        }
    }

}
