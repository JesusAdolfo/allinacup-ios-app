//
//  CustomTabBarController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 21/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import Foundation
import UIKit

// This class holds the data for my model.
class CartItem {
    
    var idUser = 0
    var totalLoyaltyPoints = 0.00
    var totalPrice = 0.00
    
    var foodId_QtityDict = [String: Int]()
    var productNamesDict = [String: String]()
    
    var myCart:[FoodItem] = []
    
}

class CustomTabBarController: UITabBarController {
    
    // Instantiate the one copy of the model data that will be accessed
    // by all of the tabs.
    var model = CartItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}