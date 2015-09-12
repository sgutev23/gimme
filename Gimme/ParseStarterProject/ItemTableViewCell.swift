//
//  ItemTableViewCell.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    private var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioConstraint {
                picture.removeConstraint(existingConstraint)
            }
        }
        
        didSet {
            if let newConstraint = aspectRatioConstraint {
                picture.addConstraint(newConstraint)
            }
        }
    }
    
    var pic: UIImage? {
        get {
            return picture.image
        }
        set {
            picture.image = newValue
            if let constraintView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constraintView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constraintView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }

}
