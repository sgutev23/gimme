//
//  Item.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

public class Item {
    let identifier: String
    let name: String
    let description: String
    let picture: UIImage?
    let friend: User?
    var boughtBy: User?
    
    public init(identifier: String, name: String, description: String, picture: UIImage?, friend: User?, boughtBy: User?) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.picture = picture
        self.friend = friend
        self.boughtBy = boughtBy
    }
}