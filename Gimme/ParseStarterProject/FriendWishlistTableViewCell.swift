//
//  FriendWishlistTableViewCelTableViewCell.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FriendWishlistTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var availableItemsLabel: UILabel!
    
    var wishlistId: String? = nil
}
