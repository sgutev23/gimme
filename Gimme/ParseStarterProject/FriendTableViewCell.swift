//
//  FriendTableViewCell.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    var friend : Friend?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wishListCounterLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var birthday: UIButton!
}
