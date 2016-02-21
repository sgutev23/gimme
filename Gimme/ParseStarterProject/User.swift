//
//  User.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

public class User {
    let firstName: String
    let lastName: String
    let identifier: String
    let email: String
    let profilePic: UIImage?
    var birthdate: NSDate?
    var numWishLists: Int = 0
    
    public init(identifier: String, firstName: String, lastName: String, email: String, birthdate: NSDate?, profilePic: UIImage?) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthdate = birthdate
        self.profilePic = profilePic
    }
}