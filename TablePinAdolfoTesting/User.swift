//
//  User.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 19/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import Foundation

class User {
    
    var _id = 0
    var address = ""
    var role = ""
    var lvl = 1
    var lastName = ""
    var gender = "male"
    var loyaltyPoints = 0.0
    var __v = 0
    var firstName = ""
    var phoneNumber = ""
    var email = ""
    
    
    
    init(_id:Int, address:String, role:String, lvl:Int, lastName:String, gender:String, loyaltyPoints:Double, firstName:String, phoneNumber:String, email:String)
    {
        self._id = _id
        self.address = address
        self.role = role
        self.lvl = lvl
        self.lastName = lastName
        self.gender = gender
        self.loyaltyPoints = loyaltyPoints
        self.firstName = firstName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
