//
//  WishlistTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class WishlistTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var currentUser = PFUser.currentUser()
    private var wishlists = [Wishlist]()
    internal var tableView = UITableView()
    private var currentSelectedWishlist: Wishlist? = nil
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.LogOutSegue {
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
            PFUser.logOut()
        }
        if segue.identifier == SeguesIdentifiers.ItemsViewSegue {
            if let destinationViewController = segue.destinationViewController as? ItemsTableViewController {
                if currentSelectedWishlist != nil {
                    destinationViewController.wishlistId = (currentSelectedWishlist?.identifier)!
                    
                    currentSelectedWishlist = nil
                }
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
    }
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        loadWishLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlists.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellFrame = CGRectMake(0, 0, self.tableView.frame.width, 52.0);
        let cell = WishlistTableViewCell(frame: cellFrame)
        let wishlist = wishlists[indexPath.row]
        
        let textLabel = UILabel(frame: CGRectMake(10.0, 0.0, UIScreen.mainScreen().bounds.width - 20.0, 52.0 - 4.0))
        textLabel.textColor = UIColor.blackColor()
        textLabel.text = wishlist.name
        
        if(!wishlist.isPublic) {
            textLabel.font = UIFont.italicSystemFontOfSize(textLabel.font.pointSize)
        }
        
        cell.addSubview(textLabel)
        cell.wishlistId = wishlist.identifier
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        currentSelectedWishlist = wishlists[indexPath.item]
        self.performSegueWithIdentifier(SeguesIdentifiers.ItemsViewSegue, sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            self.deleteWishlist(indexPath.item)
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func loadWishLists() {
        let query = PFQuery(className: DatabaseTables.Wishlist)
        query.whereKey("userid", equalTo:currentUser!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                NSLog("results: \(wishlistObjects)")
                self.wishlists.removeAll()
                if let wishlistObjects = wishlistObjects as? [PFObject] {
                    for wishlistObject in wishlistObjects {
                        self.wishlists.append(
                            Wishlist(
                                identifier: wishlistObject.objectId!,
                                name: wishlistObject["name"] as! String,
                                description: "desc",
                                isPublic: wishlistObject["public"] as! Bool))
                    }
                    self.tableView.reloadData()
                }
            } else {
                NSLog("error: \(error)")
            }
        }
    }
    
    func deleteWishlist(wishlistIndex: Int) {
        let wishlistToDelete = self.wishlists[wishlistIndex]
        
        let query = PFQuery(className: DatabaseTables.Wishlist)
        query.whereKey("objectId", equalTo: wishlistToDelete.identifier)
        query.findObjectsInBackgroundWithBlock {
            (wishlistObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let wishlistObjects = wishlistObjects as? [PFObject] {
                    for wishlistObject in wishlistObjects {
                        NSLog("Deleting wishlist with id: \(wishlistObject.objectId)")
                        wishlistObject.deleteInBackground()
                    }
                }
            } else {
                NSLog("error: \(error)")
            }
        }
        
        self.wishlists.removeAtIndex(wishlistIndex)
        self.tableView.reloadData()
    }
    
    private func createTableView() -> Void {
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
}
