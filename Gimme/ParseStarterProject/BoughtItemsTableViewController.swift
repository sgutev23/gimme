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

    private var selectedIndexPath: NSIndexPath? = nil
    private var selectedDate: NSDate? = nil
    private var items = [Item]()
    private var sectionTitles = ["My Info", "My Items"]
    private var currentUser: Friend? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.loadUser()
       // self.loadItems()
       // self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return items.count
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.MyInfoCell) as! MyInfoTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            
            if currentUser?.birthdate != nil  {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                cell.birthdateTextfield.text = dateFormatter.stringFromDate((currentUser?.birthdate)!)
                cell.birthdateTextfield.borderStyle = UITextBorderStyle.None
            }
            
            return cell
        }
        
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
    @IBAction func birthdayTextFieldSelected(sender: UITextField) {
        selectedIndexPath = self.tableView.indexPathForRowAtPoint(sender.convertPoint(sender.bounds.origin, toView: self.tableView))
        
        sender.inputView = createDatePickerView()
        sender.inputAccessoryView = createDatePickerToolBar()
    }
    
    func createDatePickerView() -> UIView {
        let inputView = UIView(frame: CGRectMake(0, 200, self.view.frame.width, 200))

        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        inputView.addSubview(datePickerView)

        return inputView
    }
    
    func createDatePickerToolBar() -> UIToolbar {
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker:")

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true;

        return toolBar
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        selectedDate = sender.date
    }

    func cancelPicker(sender: UIBarButtonItem) {
        NSLog("cancelPicker: \(selectedIndexPath?.row)")

        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.MyInfoCell, forIndexPath: selectedIndexPath!) as! MyInfoTableViewCell
        cell.birthdateTextfield.inputView?.removeFromSuperview()
        cell.birthdateTextfield.resignFirstResponder()

        tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)

        selectedDate = nil
        selectedIndexPath = nil
    }

    func donePicker(sender: UIBarButtonItem) {
        NSLog("donePicker: \(selectedIndexPath?.row)")

        if selectedIndexPath != nil && selectedDate != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.MyInfoCell, forIndexPath: selectedIndexPath!) as! MyInfoTableViewCell
            cell.birthdateTextfield.resignFirstResponder()

            tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)

//            let query = PFQuery(className: DatabaseTables.User)
//            query.getObjectInBackgroundWithId((currentUser?.identifier)!) { (userObject, error) -> Void in
//                if error != nil {
//                    NSLog("FOUND FRIEND with identifier: \((PFUser.currentUser()?.objectId)!)")
//                    userObject?.setObject(self.selectedDate!, forKey: "birthdate")
//                    userObject?.saveInBackgroundWithBlock { (success, error) -> Void in
//                        if success {
//                            NSLog("Saved BirthDate!")
//
//                            self.selectedDate = nil
//                            self.selectedIndexPath = nil
//                        } else {
//                            NSLog("Error while saving birthdate for \(self.currentUser!.firstName) \(self.currentUser!.lastName): \(error?.description)")
//                        }
//                    }
//                } else {
//                    NSLog("Cannot update birthdate for \(self.currentUser!.firstName) \(self.currentUser!.lastName).")
//                }
//            }
        }
    }
    
    private func loadUser() {
        let query = PFQuery(className: DatabaseTables.User)
        query.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId!)!, block: {
            (object, error) -> Void in
            
            if error == nil {
                self.currentUser = Friend(  identifier: object!["objectId"] as! String,
                                            firstName: object!["firstName"] as! String,
                                            lastName: object!["lastName"] as! String,
                                            birthdate: object!["birthdate"] as! NSDate?,
                                            profilePic: nil)
            } else {
                NSLog("Error: Cannot retrieve user with ID \((PFUser.currentUser()?.objectId!)!)")
            }
        })
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
                                                    birthdate: friendObject["birthday"] as! NSDate?,
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
                                                                    boughtBy: User(identifier: PFUser.currentUser()!.objectId, name: "Name not important here!"))
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
