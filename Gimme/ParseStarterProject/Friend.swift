//
//  Friend.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import QuartzCore

public class Friend: NSObject {
    let firstName: String
    let lastName: String
    let identifier: String
    let profilePic: UIImage?
    let birthday: String?
    var numWishLists: Int = 0
    
    public init(identifier: String, firstName: String, lastName: String, birthday: String?, profilePic: UIImage?) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.profilePic = profilePic
    }
}
