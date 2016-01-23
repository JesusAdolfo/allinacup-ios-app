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
    
    
    
    init(id:String, name:String, cant:Int)
    {
        self.id = id
        self.name = name
        self.cant = cant

    }
}
