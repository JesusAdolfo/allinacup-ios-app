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
    
    var itemCount = 0
    
}

class CustomTabBarController: UITabBarController {
    
     var secondItemImageView: UIImageView!
    
    // Instantiate the one copy of the model data that will be accessed
    // by all of the tabs.
    var model = CartItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func animateCart(){
        
        let secondItemView = self.tabBar.subviews[4]
        
        self.secondItemImageView = secondItemView.subviews.first as! UIImageView
        self.secondItemImageView.contentMode = .Center

        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.secondItemImageView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            self.secondItemImageView.tintColor = UIColor(red: 62/255, green: 39/255, blue: 35/255, alpha: 1)
            }, completion: { (t) -> Void in
                self.secondItemImageView.tintColor = UIColor.grayColor()
                self.secondItemImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
    }
}