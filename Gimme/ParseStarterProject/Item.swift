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
    let image: UIImage
    
    public init(identifier: String, name: String, url: String, image: UIImage) {
        self.identifier = identifier
        self.name = name
        self.url = url
        self.image = image
    }
}