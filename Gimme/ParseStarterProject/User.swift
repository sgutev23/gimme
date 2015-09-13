//
//  User.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

public class User {
    let identifier: String?
    let name: String?
    
    public init(identifier: String?, name: String?) {
        self.identifier = identifier
        self.name = name
    }
}