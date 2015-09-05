//
//  StaticData.swift
//  Gimme
//
//  Created by Daniel Mihai on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

public struct StaticData {
    public static let Wishlists: [Wishlist] = {
        var wishlists = [Wishlist]()
    
        wishlists.append(Wishlist(identifier: "wishlist-1", name: "Christmas", description: "Christmas List"))
        wishlists.append(Wishlist(identifier: "wishlist-2", name: "Birthday", description: "Birthday List"))
    
        return wishlists
    }()
    
    public static let Items: [Item] = {
        var items = [Item]()
        
        items.append(Item(identifier: "item-1", name: "Beats by Dr. Dre", url: "www.beatsbydre.com", picture: UIImage(named: "beats")))
        items.append(Item(identifier: "item-2", name: "Air Jordan 4", url: "www.jordan.com", picture: UIImage(named: "jordan")))
        
        return items
    }()
}