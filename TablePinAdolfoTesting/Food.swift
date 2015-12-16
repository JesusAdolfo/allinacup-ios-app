//
//  Food.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 11/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import Foundation

class Food {
    var name = ""
    var description = ""
    var price = 0.00
    var loyaltyPoints = 0
    var image = ""
    var isLiked = false
    
 
    
    init(name:String, description:String, price:Double, loyaltyPoints:Int, image:String, isLiked:Bool)
    {
        self.name = name
        self.description = description
        self.price = price
        self.loyaltyPoints = loyaltyPoints
        self.image = image
        self.isLiked = isLiked
    }
}
