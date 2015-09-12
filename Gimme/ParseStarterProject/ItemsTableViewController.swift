//
//  ItemsTableViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ItemsTableViewController: UITableViewController {

    var items = [Item]()
    var wishlistId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.ItemCell, forIndexPath: indexPath) as! ItemTableViewCell

        let item = items[indexPath.row]
        
        cell.urlLabel?.text = item.url
        cell.nameLabel?.text = item.name
        cell.picture.frame.size = item.picture!.size
        cell.pic = item.picture
        cell.picture.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.NewItemSegue {
            if let destination = segue.destinationViewController as? NewItemViewController {
                destination.wishlistId = wishlistId
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
        let itemToDelete = self.items[itemIndex]
        let query = PFQuery(className: DatabaseTables.Wishitem)
        
        query.whereKey("objectId", equalTo: itemToDelete.identifier)
        query.findObjectsInBackgroundWithBlock {
            (itemObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let itemObjects = itemObjects as? [PFObject] {
                    for itemObject in itemObjects {
                        NSLog("Deleting item with id: \(itemObject.objectId)")
                        itemObject.deleteInBackground()
                    }
                }
            } else {
                NSLog("error: \(error)")
            }
        }
        
        self.items.removeAtIndex(itemIndex)
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        let query = PFQuery(className: DatabaseTables.Wishitem)
        query.whereKey("wishlistId", equalTo: wishlistId!)
        query.findObjectsInBackgroundWithBlock {
            (itemObjects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                NSLog("results: \(itemObjects)")
                
                self.items.removeAll()
                
                if let itemObjects = itemObjects as? [PFObject] {
                    for itemObject in itemObjects {
                        if let picture = itemObject["picture"] as? PFFile {
                            picture.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                                if let errorMessage = error {
                                    NSLog("Error while retrieving picture: \(errorMessage)")
                                } else {
                                    self.items.append(Item(identifier: itemObject.objectId!, name: itemObject["name"] as! String, url: itemObject["description"] as! String, picture: UIImage(data: imageData!)))
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            } else {
                NSLog("Error while retrieving items: \(error)")
            }
        }
    }
    
    @IBAction func saveNewItem(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let source = segue.sourceViewController as? NewItemViewController {
            if let picture = source.imageView.image {
                let pictureData = (UIImagePNGRepresentation(cropAndScaleImage(source.scrollView)))
                let pictureName = "image-" + (PFUser.currentUser()!.objectId)! + "-" + "\(NSDate.timeIntervalSinceReferenceDate())"
                
                let file = PFFile(name: pictureName, data: pictureData!)
                file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if succeeded {
                        let item = PFObject(className: DatabaseTables.Wishitem)
                        item["wishlistId"] = source.wishlistId
                        item["picture"] = file
                        item["name"] = source.nameLabel?.text
                        item["description"] = source.descriptionLabel?.text
                        
                        item.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                NSLog("added item \(item.objectId)")
                                self.items.append(Item(identifier: item.objectId!, name: item["name"] as! String, url: item["description"] as! String, picture: picture))
                                self.tableView.reloadData()
                            } else {
                                NSLog("error adding \(error)")
                            }
                        }
                        
                    } else if let errorMessage = error {
                        NSLog("\(errorMessage)")
                    }
                    }, progressBlock: { percent in
                        NSLog("Uploaded: \(percent)")
                })
            }
        }
    }
    
    func cropAndScaleImage(scrollView: UIScrollView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offset = scrollView.contentOffset
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let pictureToSave = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(pictureToSave, nil, nil, nil)
        
        return pictureToSave
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}