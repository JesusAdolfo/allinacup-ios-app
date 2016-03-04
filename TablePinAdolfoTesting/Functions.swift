//
//  Functions.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 24/02/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//
//CLASS CREATED FOR SHARED FUNCTIONS

import Foundation
import Alamofire
import SwiftyJSON

class Functions {
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let USER_INFO: String = "/api/users/me"
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token
    
    var loyaltyPoints: Double = 0.0
    
    
    
    
    func getUserLP(completionHandler: (NSDictionary?, NSError?) -> ()){
        let myToken = userDefaults.valueForKey("token")
        getUserInfo(myToken as! String, completionHandler: completionHandler)
    }

    
    func getUserInfo(myToken: String, completionHandler: (NSDictionary?, NSError?) -> ()){
        
        let requestToken = "Bearer " + myToken
        let headers = ["Authorization": requestToken]
        let getUserInfoEndpoint: String = BASE_URL + USER_INFO
        
        Alamofire.request(.GET, getUserInfoEndpoint, headers: headers)
            .responseJSON { response in
                // handle JSON
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? NSDictionary, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
                
        }//END ALAMOFIRE POST responseJSON
    }


    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    


    
}