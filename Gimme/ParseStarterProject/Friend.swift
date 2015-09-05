//
//  Friend.swift
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

public class Friend: NSObject {
    let name: String
    let identifier: String
    
    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
