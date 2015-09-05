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
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        let friend = friends[indexPath.row]
        cell.nameLabel?.text = friend.name
        cell.wishListCounterLabel?.text = "Wishlists: 0"
        
        return cell
    }


    func loadFriends() {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let friendObjects = result["data"] as! [NSDictionary]
                for friendObject in friendObjects {
                    self.friends.append(Friend(identifier: friendObject["id"] as! String, name: friendObject["name"] as! String))
                }
                self.tableView.reloadData()
                NSLog("Friends are : \(result)")
            } else {
                NSLog("Error Getting Friends \(error)");
            }
        }
    }
    
}
