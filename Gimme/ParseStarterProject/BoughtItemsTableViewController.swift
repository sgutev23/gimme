//
//  BoughtItemsTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 11/1/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class BoughtItemsTableViewController: UITableViewController {

    private var items = [Item]()
    private var currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.BoughtItemCell) as! BoughtItemTableViewCell
        let item = items[indexPath.row]
        
        cell.friendNameLabel?.text = item.friend?.firstName
        cell.dueDateLabel?.text = "01-01-1970"
        
        if item.picture != nil {
            cell.picture.image = item.picture!
        } else {
            //TODO add default picture -
        }
        
        return cell
    }
    
    private func loadItems() {
        let query = PFQuery(className: DatabaseTables.Wishitem)
        query.whereKey("boughtBy", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (itemObjects, error) -> Void in
            
            if error == nil {
                for itemObject in itemObjects! {
                    if let wishlistId = itemObject["wishlistId"] as? String {
                        let wishlistQuery = PFQuery(className: DatabaseTables.Wishlist)
                        wishlistQuery.getObjectInBackgroundWithId(wishlistId) {
                            (wishlistObject, error) -> Void in
                            
                            if error == nil {
                                if let friendId = wishlistObject!["userid"] as? String {
                                    
                                    NSLog("FRIEND ID: \(friendId)")
                                    
                                    let friendQuery = PFQuery(className: "_User")
                                    friendQuery.getObjectInBackgroundWithId(friendId) {
                                        (friendObject, error) -> Void in
                                        
                                        if error == nil {
                                            if let friendObject = friendObject {
                                                let friend = Friend(
                                                    identifier: friendObject.objectId!,
                                                    firstName: friendObject["firstName"] as! String,
                                                    lastName: friendObject["lastName"] as! String,
                                                    profilePic: nil)
                                                
                                                if let picture = itemObject["picture"] as? PFFile {
                                                    picture.getDataInBackgroundWithBlock {
                                                        (imageData, error) -> Void in
                                                        
                                                        if error == nil {
                                                            self.items.append(
                                                                Item(
                                                                    identifier: itemObject.objectId!!,
                                                                    name: itemObject["name"] as! String,
                                                                    url: itemObject["description"] as! String,
                                                                    picture: UIImage(data: imageData!),
                                                                    friend: friend,
                                                                    boughtBy: User(identifier: self.currentUser!.objectId, name: "Name not important here!"))
                                                            )
                                                        } else {
                                                            NSLog("Cannot retrieve picture: \(error?.localizedDescription)")
                                                        }
                                                        self.tableView.reloadData()
                                                    }
                                                }
                                            }
                                        } else {
                                            NSLog("Cannot retrieve item's friend: \(error?.localizedDescription)")
                                        }
                                    }
                                }
                            } else {
                                NSLog("Cannot retrieve item's wishlist: \(error?.localizedDescription)")
                            }
                        }
                    }
                }
            } else {
                NSLog("Cannot retrieve bought items: \(error?.localizedDescription)")
            }
        }
    }
}
