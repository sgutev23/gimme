//
//  DashboardViewController.swift
//  Gimme
//
//  Created by Daniel Mihai on 10/31/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navCon = segue.destinationViewController as? UINavigationController {
            let destination = navCon.visibleViewController
            
            if let currentViewController = destination as? CurrentViewController {
                if let identifier = segue.identifier {
                    switch identifier {
                    case "items": currentViewController.label.text = "Items"
                    case "lists": currentViewController.label.text = "Lists"
                    case "friends": currentViewController.label.text = "Friends"
                    default: currentViewController.label.text = "Nada"
                    }
                }
            }

        }
        
    }
    
}
