//
//  Food.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 11/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import Foundation

class Food {
    var id = ""
    var name = ""
    var description = ""
    var price = 0.00
    var loyaltyPoints = 0
    var image = ""
    
    var qtity = 0
    var totalLP = 0
    var totalPrice = 0.00
    
 
    
    init(id: String, name:String, description:String, price:Double, loyaltyPoints:Int, image:String, isLiked:Bool)
    {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.loyaltyPoints = loyaltyPoints
        self.image = image
    }
}
