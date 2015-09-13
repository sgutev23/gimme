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
    let url: String
    let picture: UIImage?
    var boughtBy: User?
    
    public init(identifier: String, name: String, url: String, picture: UIImage?, boughtBy: User?) {
        self.identifier = identifier
        self.name = name
        self.url = url
        self.picture = picture
        self.boughtBy = boughtBy
    }
}