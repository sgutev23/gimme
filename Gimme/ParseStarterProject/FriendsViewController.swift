//
//  FriendsViewController.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private var friends = [User]()
    //private var selectedIndexPath: NSIndexPath? = nil
    //private var selectedDate: NSDate? = nil
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
        //cell.wishListCounterLabel?.text = "WISHLISTS: " + String(friend.numWishLists)
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
                let friendObjects = result["data"] as! [NSDictionary]
                var friendIdsArray = [String]()

                for friendObject in friendObjects {
                    let friendId = friendObject["id"] as! String;
                    friendIdsArray.append(friendId)
                }

//                let query = PFQuery(className:"_User")
//                NSLog("friendsArray \(friendIdsArray)")
//                
//                query.whereKey("facebookId", containedIn: friendIdsArray)
//                query.findObjectsInBackgroundWithBlock {
//                    (friendUserids: [AnyObject]?, error: NSError?) -> Void in
//                    if error == nil {
//                        if let friendUserids = friendUserids as? [PFObject] {
//                            for friendUserid in friendUserids {
//                                let objectId = friendUserid.objectId!
//                                
//                                if let profilePictureFile = friendUserid["profilePicture"] as? PFFile {
//                                    profilePictureFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
//                                        var profilePicture: UIImage? = nil
//                                        
//                                        if error == nil {
//                                            profilePicture = UIImage(data: imageData!)
//                                        } else {
//                                            NSLog("Error retrieving profile pic data for user \(objectId): \(error?.localizedDescription).")
//                                        }
//                                        
//                                        let friend = Friend(
//                                            identifier: objectId,
//                                            firstName: friendUserid["firstName"] as! String,
//                                            lastName: friendUserid["lastName"] as! String,
//                                            birthdate: friendUserid["birthdate"] as! NSDate?,
//                                            profilePic: profilePicture)
//                                        self.friends.append(friend)
//                                        self.loadWishlistCount(friend)
//                                    }
//                                }
//                            }
//                            
//                        }
//                    } else {
//                        NSLog("error: \(error)")
//                    }
//
//                }
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
//        let query = PFQuery(className: DatabaseTables.Wishlist)
//        query.whereKey("userid", equalTo: friend.identifier)
//        query.whereKey("public", equalTo: true)
//        
//        query.countObjectsInBackgroundWithBlock {
//            (count, error) -> Void in
//            
//            if error == nil {
//                NSLog("NUMBER OF WISHLISTS for \(friend.identifier): \(count)")
//                friend.numWishLists = Int(count)
//                self.tableView.reloadData()
//            } else {
//                NSLog("Error getting the number of wishlists for friend \(friend.identifier): \(error?.localizedDescription)")
//            }
//            
//        }
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
    
//    @IBAction func birthdayTextFieldSelected(sender: UITextField) {
//        selectedIndexPath = self.tableView.indexPathForRowAtPoint(sender.convertPoint(sender.bounds.origin, toView: self.tableView))
//        
//        NSLog("Selected Index: \(selectedIndexPath?.row)")
//        
//        sender.inputView = createDatePickerView()
//        sender.inputAccessoryView = createDatePickerToolBar()
//    }
//    
//    func createDatePickerView() -> UIView {
//        let inputView = UIView(frame: CGRectMake(0, 200, self.view.frame.width, 200))
//        
//        let datePickerView = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
//        inputView.addSubview(datePickerView)
//        
//        return inputView
//    }
//    
//    func createDatePickerToolBar() -> UIToolbar {
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker:")
//        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        toolBar.sizeToFit()
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true;
//        
//        return toolBar
//    }
// 
//    func handleDatePicker(sender: UIDatePicker) {
//        selectedDate = sender.date
//    }
//    
//    func cancelPicker(sender: UIBarButtonItem) {
//        NSLog("cancelPicker: \(selectedIndexPath?.row)")
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendCell, forIndexPath: selectedIndexPath!) as! FriendTableViewCell
//        cell.birthdayTextField.inputView?.removeFromSuperview()
//        cell.birthdayTextField.resignFirstResponder()
//        
//        tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
//        
//        selectedDate = nil
//        selectedIndexPath = nil
//    }
//    
//    func donePicker(sender: UIBarButtonItem) {
//        NSLog("donePicker: \(selectedIndexPath?.row)")
//        
//        if selectedIndexPath != nil && selectedDate != nil {
//            let friend = friends[(selectedIndexPath?.row)!]
//            friend.birthdate = selectedDate
//            
//            let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.FriendCell, forIndexPath: selectedIndexPath!) as! FriendTableViewCell
//            cell.birthdayTextField.resignFirstResponder()
//            
//            tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
//            
//            let query = PFQuery(className: DatabaseTables.User)
//            query.getObjectInBackgroundWithId(friend.identifier) { (friendObject, error) -> Void in
//                if error != nil {
//                    NSLog("FOUND FRIEND with identifier: \(friend.identifier)")
//                    friendObject?.setObject(self.selectedDate!, forKey: "birthdate")
//                    friendObject?.saveInBackgroundWithBlock { (success, error) -> Void in
//                        if success {
//                            NSLog("Saved BirthDate!")
//                            
//                            self.selectedDate = nil
//                            self.selectedIndexPath = nil
//                        } else {
//                            NSLog("Error while saving birthdate for \(friend.firstName) \(friend.lastName): \(error?.description)")
//                        }
//                    }
//                } else {
//                    NSLog("Cannot update birthdate for \(friend.firstName) \(friend.lastName).")
//                }
//            }
//        }
//    }
}
