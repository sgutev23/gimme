//
//  PopoverViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 1/31/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var wishlistsNumberLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    
    var wishlistsNumber: Int!
    var birthdate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.93, alpha: 1.00)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        birthdateLabel.text = birthdate == nil ? "Not set yet" : dateFormatter.stringFromDate(birthdate)
        wishlistsNumberLabel.text = "WISHLISTS: \(wishlistsNumber)"
    }
}
