//
//  Wishlist.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

public class Wishlist {
    let identifier: String
    let name: String
    let description: String
    let isPublic: Bool
    
    public init(identifier: String, name: String, description: String, isPublic: Bool) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.isPublic = isPublic
    }
}