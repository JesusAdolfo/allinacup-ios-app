//
//  FoodItem.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 19/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import Foundation


class FoodItem {
    
    var id = ""
    var name = ""
    var cant = 0
    
    
    var description = ""
    var price = 0.00
    var lp = 0
    var image = ""
    
    var subTotalLP = 0
    var subTotalPrice = 0.00
    
    
    init(id:String, name:String, cant:Int, description:String, price:Double, lp:Int, image: String, subTotalLP: Int, subTotalPrice: Double)
    {
        self.id = id
        self.name = name
        self.cant = cant
        
        self.description = description
        self.price = price
        self.lp = lp
        self.image = image
        
        self.subTotalLP = subTotalLP
        self.subTotalPrice = subTotalPrice

    }
}
