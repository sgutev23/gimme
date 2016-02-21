//
//  FriendItemsTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FriendItemsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var wishlistId: String? = nil

    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        self.tableView.reloadData()
    }


    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendItemCell, forIndexPath: indexPath) as! FriendItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.urlLabel?.text = item.description
        cell.nameLabel?.text = item.name
        
        if item.picture != nil {
            cell.picture.image = item.picture!
        } else {
            //TODO: add default picture
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let item = items[indexPath.row]
        var buttons: [UITableViewRowAction] = []
        if item.boughtBy != nil {
            let unmarkItem = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Unmark", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
                self.changeItemBuyState(indexPath.row, buy: false)
            })
            unmarkItem.backgroundColor = UIColor.redColor()
            
            buttons.append(unmarkItem)
        } else {
            let buyItem = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Buy", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
                self.changeItemBuyState(indexPath.row, buy: true)
            })
            buyItem.backgroundColor = UIColor.greenColor()
            
            buttons.append(buyItem)
        }
        
        return buttons
    }
    
    private func changeItemBuyState(itemIndex: Int, buy: Bool) {
//        let item = items[itemIndex]
//        let query = PFQuery(className: DatabaseTables.Wishitem)
//        
//        query.getObjectInBackgroundWithId(item.identifier) {
//            (object, error) -> Void in
//            
//            if error == nil {
//                if let object = object {
//                    object.setObject(self.currentUser!, forKey: "boughtBy")
//                    object.saveInBackgroundWithBlock {
//                        (success, error) -> Void in
//                        
//                        if success {
//                            item.boughtBy = buy ? User(identifier: self.currentUser?.objectId, name: self.currentUser?["name"] as? String) : nil
//                            self.tableView.reloadData()
//                            NSLog("Saved item's boughtBy user")
//                        } else {
//                            NSLog("Cannot save object: \(error?.localizedDescription)")
//                        }
//                    }
//                }
//            } else {
//                NSLog("Cannot buy item: \(error)")
//            }
//        }
    }

    private func loadItems() {
//        let query = PFQuery(className: DatabaseTables.Wishitem)
//
//        query.whereKey("wishlistId", equalTo: self.wishlistId!)
//        query.findObjectsInBackgroundWithBlock {
//            (itemObjects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                self.items.removeAll()
//                
//                if let itemObjects = itemObjects as? [PFObject] {
//                    for itemObject in itemObjects {
//                        var boughtByUser: User? = nil
//                        if let boughtBy = itemObject["boughtBy"] as? PFUser {
//                            boughtByUser = User(identifier: boughtBy["objectId"] as? String, name: (boughtBy["firstName"] as! String))
//                        }
//                        
//                        if let picture = itemObject["picture"] as? PFFile {
//                            picture.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                                if let errorMessage = error {
//                                    NSLog("Error while retrieving picture: \(errorMessage)")
//                                } else {
//                                    self.items.append(
//                                        Item(
//                                            identifier: itemObject.objectId!,
//                                            name: itemObject["name"] as! String,
//                                            url: itemObject["description"] as! String,
//                                            picture: UIImage(data: imageData!),
//                                            friend: nil,
//                                            boughtBy: boughtByUser))
//                                    
//                                    self.tableView.reloadData()
//                                }
//                            }
//                        } else {
//                            self.items.append(
//                                Item(
//                                    identifier: itemObject.objectId!,
//                                    name: itemObject["name"] as! String,
//                                    url: itemObject["description"] as! String,
//                                    picture: nil,
//                                    friend: nil,
//                                    boughtBy: boughtByUser))
//                            
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            } else {
//                NSLog("Error while retrieving items: \(error)")
//            }
//        }
    }
}