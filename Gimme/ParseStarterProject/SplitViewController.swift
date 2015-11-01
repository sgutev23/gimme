//
//  SplitViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 11/1/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.preferredDisplayMode = .PrimaryHidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
