//
//  FriendsViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

class FriendsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private var friends = [User]()
    private let dateFormat = "dd MMM yyyy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        cell.profilePic.image = friend.profilePic
        cell.profilePic.clipsToBounds = true;
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
        cell.profilePic.layer.borderWidth = 1.0;
        let borderColor : UIColor = UIColor.lightGrayColor()
        cell.profilePic.layer.borderColor = borderColor.CGColor;
        
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor(red:0.93, green:0.98, blue:0.93, alpha:1.00)
        cell.selectedBackgroundView = backgroundColorView
        
        return cell
    }
   
    func loadFriends() {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                self.friends.removeAll()
                
                let friendObjects = result["data"] as! [NSDictionary]
                
                for friendObject in friendObjects {
                    let friendId = friendObject["id"] as! String;
                    
                    ref.childByAppendingPath("users")
                        .queryOrderedByChild("identifier")
                        .queryEqualToValue("facebook:\(friendId)")
                        .observeSingleEventOfType(.Value, withBlock: {
                            snapshot in
                            
                            if snapshot.value is NSNull {
                                NSLog("error while retrieving friend: \(snapshot)")
                            } else {
                                let enumerator = snapshot.children
                                while let single = enumerator.nextObject() as? FDataSnapshot {
                                    let formatter = NSDateFormatter()
                                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                                    
                                    let firstName = single.value.objectForKey("firstName") as! String
                                    let lastName = single.value.objectForKey("lastName") as! String
                                    let profilePic = single.value.objectForKey("profilePic") as! String
                                    let email = single.value.objectForKey("email") as! String
                                    let birthdateString = single.value.objectForKey("birthdate") as! String
                                    let birthdate = formatter.dateFromString(birthdateString)
                                    let decodedData = NSData(base64EncodedString: profilePic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                    let friend = User(identifier: friendId,firstName: firstName,lastName: lastName,email: email,birthdate: birthdate,profilePic: UIImage(data: decodedData!))
                                    
                                    self.friends.append(friend)
                                    self.loadWishlistCount(friend)
                                    self.tableView.reloadData()
                                }
                            }
                        })
                }
                NSLog("Friends are : \(result)")
            } else {
                NSLog("Error Getting Friends \(error)");
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    
    func loadWishlistCount(friend: User) {
        ref.childByAppendingPath("wishlists").queryOrderedByChild("userid").queryEqualToValue("facebook:\(friend.identifier)")
            .observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                if snapshot.value is NSNull {
                    NSLog("error while retrieving friends' wishlist count: \(snapshot)")
                } else {
                    friend.numWishLists = snapshot.children.allObjects.count
                    self.tableView.reloadData()
                }
            })
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

    @IBAction func showFriendInfo(sender: UIButton) {
        let selectedIndexPath = self.tableView.indexPathForRowAtPoint(sender.convertPoint(sender.bounds.origin, toView: self.tableView))
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendCell, forIndexPath: selectedIndexPath!) as! FriendTableViewCell
        let friend = friends[selectedIndexPath!.row]
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(ViewControllers.FriendInfoPopover) as! PopoverViewController
        
        popover.birthdate = friend.birthdate
        popover.wishlistsNumber = friend.numWishLists
        popover.modalPresentationStyle = UIModalPresentationStyle.Popover
        popover.popoverPresentationController?.backgroundColor = UIColor(red: 0.93, green: 0.90, blue: 0.93, alpha: 1.0)
        popover.popoverPresentationController?.delegate = self
        popover.popoverPresentationController?.sourceView = cell
        popover.popoverPresentationController?.sourceRect = cell.bounds
        popover.popoverPresentationController?.permittedArrowDirections = .Any
        popover.preferredContentSize = CGSizeMake(320, 120)
        
        self.presentViewController(popover, animated: true, completion: nil)
    }
}
