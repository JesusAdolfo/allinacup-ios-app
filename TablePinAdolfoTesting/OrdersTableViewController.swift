//
//  OrdersTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 03/03/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrdersTableViewController: UITableViewController {
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let ORDERS_URL: String = "/api/client-requests/by-user"
    
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var orders:[Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100.0; self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //calling the preious orders from the server
        getPreviousOrders()
        
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
        return orders.count
    }
    
    func getPreviousOrders(){
        let myToken: String = userDefaults.valueForKey("token") as! String
        let requestToken = "Bearer " + myToken
        let headers = ["Authorization": requestToken]
        let getPreviousOrdersEndpoint: String = BASE_URL + ORDERS_URL
        
        Alamofire.request(.GET, getPreviousOrdersEndpoint, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let ordersJSON = JSON(value)
                        for (_, subJson) in ordersJSON {
                            
                            let id = subJson["request"]["_id"].stringValue
                            let idUser = subJson["request"]["idUser"].stringValue
                            let createdAt = subJson["request"]["createdAt"].stringValue
                            let status = subJson["request"]["status"].stringValue
                            
                            
                            var totalPrice = 0
                            var totalLP = 0
                            var itemCount = 0
                            var cart = [String]()
                            let cartJSON = subJson["car"]
                            for(_, subcartJSON) in cartJSON{
                                
                                let itemQty: Int!
                                if(subcartJSON["cantA"].intValue == 0){
                                        itemQty = subcartJSON["cant"].intValue
                                }else{
                                        itemQty = subcartJSON["cantA"].intValue
                                }
                                
                                let itemName = subcartJSON["name"].stringValue
                                let itemPrice = subcartJSON["price"].intValue
                                let itemLP = subcartJSON["loyaltyPoints"].intValue
                                
                                cart.append("\(itemQty) x \(itemName)")
                                
                                totalPrice = totalPrice +  (itemQty * itemPrice)
                                totalLP = totalLP + (itemQty * itemLP)
                                itemCount++

                            }
                            
                            let loadedOrder = Order(id: id, idUser: idUser, createdAt: createdAt, status: status, totalLP: totalLP, totalPrice: totalPrice, itemCount: itemCount, cart: cart)
                            self.orders.append(loadedOrder)
                            
                            dump(loadedOrder)
                            self.do_table_refresh()
                            
                        }
                    }
                case .Failure( _):
                    print("there was an error getting the orders")
                    self.alert("Connection problems", customMessage: "Please, check your internet connection")
                    
                }
        }//END ALAMOFIRE POST responseJSON
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "orderCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderTableViewCell
        
        cell.orderIdLabel.text = "Order #" + orders[indexPath.row].id
        cell.dateLabel.text = orders[indexPath.row].createdAt
        cell.processedLabel.text = orders[indexPath.row].status
        cell.processedLabel.textColor = cell.processedLabel.text == "processed" ? UIColor.greenColor() : UIColor.redColor()
        cell.countLabel.text = "Products: " + String(orders[indexPath.row].itemCount)
        cell.totalLpLabel.text = "Total LP: " + String(orders[indexPath.row].totalLP)
        cell.totalPriceLabel.text = "Total: " + String(orders[indexPath.row].totalPrice)
        
        var listString = ""
        
        for item in orders[indexPath.row].cart{
            listString = listString + "\n" + item
        }
        
        cell.productListLabel.text = listString + "\n"
        
        //disable cell highlighting
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
  

    func alert(alertTitle:String, customMessage: String){
        //FAILED LOGIN ALERT
        let Alert = UIAlertController(title: alertTitle, message: customMessage, preferredStyle: .Alert)
        let AlertAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        Alert.addAction(AlertAction)
        self.presentViewController(Alert, animated: true) {
            // ...
        }
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }



}
