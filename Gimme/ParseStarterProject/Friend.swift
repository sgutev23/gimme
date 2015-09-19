//
//  Friend.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

public class Friend: NSObject {
    let firstName: String
    let lastName: String
    let identifier: String
    let profilePic: UIImage?
    var numWishLists: Int = 0
    
    public init(identifier: String, firstName: String, lastName: String, profilePic: UIImage?) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
    }
}
