//
//  ItemsTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Firebase

class ItemsTableViewController: UITableViewController {
    
    var items = [Item]()
    var wishlist: Wishlist? = nil
    
    @IBOutlet weak var uploadProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadProgressView.hidden = true
        self.loadItems()
        self.tableView.reloadData()
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
        return items.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.ItemCell, forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.descriptionLabel?.text = item.description
        cell.nameLabel?.text = item.name
        
        if item.picture != nil {
            cell.picture.image = item.picture
            cell.picture.layer.borderWidth = 1.0;
            let borderColor : UIColor = UIColor.lightGrayColor()
            cell.picture.layer.borderColor = borderColor.CGColor;
        } else {
            //TODO: add default picture - like a question mark or something
        }
        
        if item.boughtBy != nil {
            cell.reservedImage.alpha = 1.0
        } else {
            cell.reservedImage.alpha = 1.0
            cell.reservedImage.clipsToBounds = true;
            cell.reservedImage.layer.cornerRadius = cell.reservedImage.frame.size.width / 2;
            cell.reservedImage.layer.borderWidth = 2.0;
            let borderColor : UIColor = UIColor.whiteColor()
            cell.reservedImage.layer.borderColor = borderColor.CGColor;
            
        }
        
        
        let topBorder = UIView();
        topBorder.backgroundColor = UIColor.whiteColor();
        topBorder.frame = CGRectMake(0, 0, cell.placeholderView.frame.size.width, 3);
        cell.placeholderView.addSubview(topBorder)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.NewItemSegue {
            if let destination = segue.destinationViewController as? NewItemViewController {
                destination.wishlist = wishlist
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete", handler: { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            self.deleteItem(indexPath.item)
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func deleteItem(itemIndex: Int) {
        //        let itemToDelete = self.items[itemIndex]
        //        let query = PFQuery(className: DatabaseTables.Wishitem)
        //
        //        query.whereKey("objectId", equalTo: itemToDelete.identifier)
        //        query.findObjectsInBackgroundWithBlock {
        //            (itemObjects: [AnyObject]?, error: NSError?) -> Void in
        //            if error == nil {
        //                if let itemObjects = itemObjects as? [PFObject] {
        //                    for itemObject in itemObjects {
        //                        NSLog("Deleting item with id: \(itemObject.objectId)")
        //                        itemObject.deleteInBackground()
        //                    }
        //                }
        //            } else {
        //                NSLog("error: \(error)")
        //            }
        //        }
        //
        //        self.items.removeAtIndex(itemIndex)
        //        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        ref.childByAppendingPath("wishlists")
            .childByAppendingPath(wishlist!.identifier)
            .childByAppendingPath("items")
            .queryOrderedByValue()
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    NSLog("error")
                } else {
                    self.items.removeAll()
                    let enumerator = snapshot.children
                    while let single = enumerator.nextObject() as? FDataSnapshot {
                        let name = single.value.objectForKey("name") as! String;
                        let description = single.value.objectForKey("description") as! String
                        let itemId = single.value.objectForKey("identifier") as! String
                        let base64EncodedImage = single.value.objectForKey("pictureData") as! String
                        var decodedimage : UIImage?
                      //  if base64EncodedImage != "" {
                       //     let decodedData = NSData(base64EncodedString: base64EncodedImage, options: NSDataBase64DecodingOptions(rawValue: 0))
                      //      decodedimage = UIImage(data: decodedData!)
                      //  }
                        NSLog ("\(single)")
                        self.items.append(
                            Item(identifier: itemId,
                                name: name,
                                description: description,
                                picture: decodedimage,
                                friend: nil,
                                boughtBy: nil))
                        
                    }
                    self.tableView.reloadData()
                }
            })
        
        //        let wishlistQuery = PFQuery(className: DatabaseTables.Wishlist)
        //        let query = PFQuery(className: DatabaseTables.Wishitem)
        //
        //        wishlistQuery.whereKey("objectId", equalTo: wishlist!.identifier)
        //
        //        query.whereKey("wishlist", matchesQuery: wishlistQuery)
        //        query.findObjectsInBackgroundWithBlock {
        //            (itemObjects: [AnyObject]?, error: NSError?) -> Void in
        //            if error == nil {
        //                self.items.removeAll()
        //
        //                if let itemObjects = itemObjects as? [PFObject] {
        //                    for itemObject in itemObjects {
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
        //                                            boughtBy: nil))
        //                                    self.tableView.reloadData()
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            } else {
        //                NSLog("Error while retrieving items: \(error)")
        //            }
        //        }
    }
    
    @IBAction func saveNewItem(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let source = segue.sourceViewController as? NewItemViewController {
            let resizedPicture = cropAndScaleImage(source.scrollView)
             let pictureData = (UIImagePNGRepresentation(resizedPicture))
            let uuid = NSUUID().UUIDString
            let pictureName = "image-" + currentUser!.identifier + "-" + "\(uuid)"
            
            let base64String = pictureData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            let newItem = [
                "identifier" : pictureName,
                "pictureData": base64String,
                "name" : source.nameLabel.text!,
                "description" : source.descriptionLabel.text!,
                "userId": currentUser!.identifier,
                "wishlistId" : (source.wishlist?.identifier)!
            ]
            
            NSLog("data to store: \(newItem)")
            ref.childByAppendingPath("wishlists")
                .childByAppendingPath((source.wishlist?.identifier)!)
                .childByAppendingPath("items")
                .childByAppendingPath(pictureName)
                .setValue(newItem)
        }
        
    }
    
    private func addAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: false, completion: nil)
    }
    
    //    private func saveNewItem(wishlist: Wishlist?, name: String?, description: String?, file: PFFile?) -> Void {
    //        let wishlistQuery = PFQuery(className: DatabaseTables.Wishlist)
    //
    //        wishlistQuery.getObjectInBackgroundWithId((wishlist?.identifier)!) {
    //            (wishlistObject: PFObject?, error: NSError?) -> Void in
    //
    //            if error == nil && wishlistObject != nil {
    //                let item = PFObject(className: DatabaseTables.Wishitem)
    //                item.setObject(wishlistObject!, forKey: "wishlist")
    //                item.setObject(file ?? NSNull(), forKey: "picture")
    //                item.setObject(name!, forKey: "name")
    //                item.setObject(description!, forKey: "description")
    //                item.ACL = PFACL(user: PFUser.currentUser()!)
    //                item.ACL?.setPublicReadAccess(true)
    //                item.ACL?.setPublicWriteAccess(true)
    //                item.saveInBackgroundWithBlock {
    //                    (success: Bool, error: NSError?) -> Void in
    //                    if (success) {
    //                        NSLog("added item \(item.objectId)")
    //                        self.items.append(
    //                            Item(
    //                                identifier: item.objectId!,
    //                                name: item["name"] as! String,
    //                                url: item["description"] as! String,
    //                                picture: file == nil ? nil : UIImage(data: file!.getData()!),
    //                                friend: nil,
    //                                boughtBy: nil))
    //
    //                        self.uploadProgressView.hidden = true
    //                        self.tableView.reloadData()
    //                    } else {
    //                        NSLog("error adding item \(error)")
    //                    }
    //                }
    //            } else {
    //                if(wishlistObject == nil) {
    //                    NSLog("Error retrieving wishlist: the 'wishlistObject' is nil.")
    //                } else {
    //                    NSLog("Error retrieving wishlist: \(error)")
    //                }
    //
    //            }
    //        }
    //    }
    
    private func cropAndScaleImage(scrollView: UIScrollView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offset = scrollView.contentOffset
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let pictureToSave = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return pictureToSave
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}