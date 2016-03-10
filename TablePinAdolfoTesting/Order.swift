//
//  Order.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 06/03/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import Foundation

class Order{
    
    var id = ""
    var idUser = ""
    var createdAt = ""
    var status = ""
    
    var totalLP = 0
    var totalPrice = 0
    var itemCount = 0
    
    var cart = [String]()
    
    init(id:String, idUser:String, createdAt:String, status:String, totalLP:Int, totalPrice:Int, itemCount:Int, cart: [String])
    {
        self.id = id
        self.idUser = idUser
        self.createdAt = createdAt
        self.status = status
        self.totalLP = totalLP
        self.totalPrice = totalPrice
        self.itemCount = itemCount
        self.cart = cart
    }
}