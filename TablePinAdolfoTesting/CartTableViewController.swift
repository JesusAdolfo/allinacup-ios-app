//
//  CartTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 20/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //dump()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    override func viewWillAppear(animated: Bool) {
        // Get a reference to the model data from the custom tab bar controller.
        let cart = (self.tabBarController as! CustomTabBarController).model
        
        // This tab will simply access the data and display it when the view
        // appears.
        
        dump(cart.myCart)
        
        if(cart.totalPrice == 0 && cart.totalLoyaltyPoints == 0){
            print("Your cart is empty :(")
        }else{
            
            
            let idUser = cart.idUser
            let totalLP = cart.totalLoyaltyPoints
            let totalPrice = cart.totalPrice
            let cartArray = cart.myCart
            
            var json: JSON =  ["idUser": idUser, "total_loyalty_points": totalLP, "total_price": totalPrice, "car": []]
            
  
            var cars = [[String: NSObject]]()
            for object in cart.myCart{
                var name = [String: NSObject]()
                name["id"] = object.id
                name["name"] = object.name
                name["cant"] = object.cant
                
                
                let sortedDict = name.sort { $0.0 > $1.0 }
                
                print(sortedDict)
                
                cars.append(name)
            }
            json["car"] = JSON(cars)
            
            print(json)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    //func getProductNameById()
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
