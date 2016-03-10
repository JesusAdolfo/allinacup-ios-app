//
//  CartTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 20/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


//overloading the + operator
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.appendAttributedString(left)
    result.appendAttributedString(right)
    return result
}

class CartTableViewController: UITableViewController {

    @IBOutlet var processOrderButton: UIButton!
    @IBOutlet var orderWarningLabel: UILabel!
    
    @IBOutlet var totalLoyaltyLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let ORDER_URL: String = "/api/client-requests"
    
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token
    
    var number_of_rows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        //Refresshes the table everytime a tab appears
        self.do_table_refresh()
        
        
        let cart = (self.tabBarController as! CustomTabBarController).model
        number_of_rows = cart.myCart.count

        dump(cart.myCart)
        
        //CHECKS IF THE CART IS EMPTY
        if(cart.totalPrice == 0){
            processOrderButton.hidden = true
            alert("Your cart is empty", customMessage: "You must add items to your cart to preview your order")
            switchToDataTab()
        }else{
            processOrderButton.hidden = false
            displayCartPriceAndLoyaltyPoints()
        }

        
        
    }
    
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    func switchToDataTab(){
        NSTimer.scheduledTimerWithTimeInterval(0.2,
            target: self,
            selector: "switchToDataTabCont",
            userInfo: nil,
            repeats: false)
    }
    
    func switchToDataTabCont(){
        tabBarController!.selectedIndex = 0
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
        return number_of_rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cart = (self.tabBarController as! CustomTabBarController).model
        
        print("my cart when drawing the table is")
        dump(cart.myCart)
        
        let cellIdentifier = "CartCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        
        //disable cell highlighting
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let cartRowCount = cart.myCart.count
        
        if cartRowCount > 0{
            // Configure the cell...
            cell.nameLabel.text = cart.myCart[indexPath.row].name
            cell.descriptionLabel.text = cart.myCart[indexPath.row].description
            
            
            let value: Double = cart.myCart[indexPath.row].price
            let unit: String = " ₩"
            let itemPriceString = String.localizedStringWithFormat("%@%.0f ", value, unit)
            cell.priceLabel.text = itemPriceString
            cell.loyaltyLabel.text = "LP: " + String(cart.myCart[indexPath.row].lp)
            
            
            
            if let myToken = userDefaults.valueForKey("token"){
                let requestToken = "Bearer " + (myToken as! String)
                let headers = ["Authorization": requestToken, "Content-Type": "image/jpg"]
                let imageEndPoint = cart.myCart[indexPath.row].image
                
                let imageId = "image_" + String(cart.myCart[indexPath.row].id)
                
                //MATCHING THE SERVER RESPONSE TO THE RESPONSE ACCEPTED BY ALAMOFIREIMAGE
                Request.addAcceptableImageContentTypes(["image/jpg"])
                
                
                
                let imageCache = AutoPurgingImageCache()
                
                let URLRequest = NSURLRequest(URL: NSURL(string: imageEndPoint)!)
                
                Alamofire.request(.GET, imageEndPoint, headers: headers)
                    .responseImage { response in
                        
                        if let image = response.result.value {
                            //Add image to cache
                            imageCache.addImage(
                                image,
                                forRequest: URLRequest,
                                withAdditionalIdentifier: imageId
                            )
                            
                            let cachedAvatarImage = imageCache.imageForRequest(
                                URLRequest,
                                withAdditionalIdentifier: imageId
                            )
                            //cell.thumbnailImageView.af_setImageWithURL(NSURL(string: imageEndPoint)!)
                            cell.thumbnailImageView.image = cachedAvatarImage
                        }
                }//ENDS ALAMOFIREIMAGE REQUEST
                
                
                cell.qtyLabel.text = "Quantity: " + String(cart.myCart[indexPath.row].cant)
                
                cart.myCart[indexPath.row].subTotalLP = cart.myCart[indexPath.row].lp *  cart.myCart[indexPath.row].cant
                cell.loyaltyPointsLabel.text = "Sub-Total Loyalty Points: " + String(cart.myCart[indexPath.row].subTotalLP)
                
                let subTotalPrice = cart.myCart[indexPath.row].price *  Double(cart.myCart[indexPath.row].cant)
                let subTotalValue: Double = subTotalPrice
                let unit: String = " ₩"
                let subTotalPriceString = String.localizedStringWithFormat("%@%.0f ", subTotalValue, unit)
                cell.totalPriceLabel.text = "Sub-Total: " +  subTotalPriceString
                
                cell.addButton.tag = indexPath.row
                cell.removeButton.tag = indexPath.row
                
        }else{
                print("El carrito ta vacio el mio")
        }
        
        
            
            
        }


        return cell
    }
    
    @IBAction func processOrderButtonTapped(sender: AnyObject) {

        let cart = (self.tabBarController as! CustomTabBarController).model
            
            let idUser = cart.idUser
            let totalLP = cart.totalLoyaltyPoints
            let totalPrice = cart.totalPrice
            
            var cars = [[String: AnyObject]]()
            for object in cart.myCart{
                var name = [String: AnyObject]()
                name["id"] = object.id
                name["name"] = object.name
                name["cant"] = object.cant
                
                cars.append(name)
            }
        
        
        
            //actually proccessing the order (when the "proccess order" button is tapped)
            proccessOrder(idUser, totalLP: totalLP, totalPrice: totalPrice, cars: cars)
            
    }
    
    func proccessOrder(idUser: Int, totalLP: Double, totalPrice: Double, cars: [[String: AnyObject]] ){
        if let myToken = userDefaults.valueForKey("token"){
            let requestToken = "Bearer " + (myToken as! String)
            let headers = ["Authorization": requestToken, "Content-Type": "application/json"]
            let orderProductsEndpoint: String = BASE_URL + ORDER_URL
            
            let parameters:[String : AnyObject] = [
                "idUser": idUser,
                "total_loyalty_points": totalLP,
                "total_price": totalPrice,
                "car": cars
            ]
            
            
            Alamofire.request(.POST, orderProductsEndpoint, headers:headers, parameters: parameters, encoding: .JSON)
                .responseJSON{ response in
                    switch response.result {
                    case .Success(let value):
                        //create alert to let the user know the order was successful
                        let orderResponseJSON = JSON(value)
                        let order = orderResponseJSON["order"].stringValue
                        let orderDate = orderResponseJSON["date"].stringValue
                        print(orderDate)
                        
                        if order == ""{
                            let message = "There was an error while processing the order. \n Please, try later!"
                            self.alert("Error" , customMessage: message)
                        }else{
                            let message = "Your order number is #" + order
                            self.alert("Order successful" , customMessage: message)
                            
                            let cart = (self.tabBarController as! CustomTabBarController).model
                            cart.myCart.removeAll()
                            cart.totalPrice = 0
                            cart.totalLoyaltyPoints = 0
                            cart.itemCount = 0
 
                        }
                        
                        
                    case .Failure(let error):
                        print(error)
                        
                        //create alert to let the user know there was an error
                        let message = "There was an error while processing the order"
                        self.alert("Communication Error" , customMessage: message)
                    }
            }
        }
    }
    
    func alert(alertTitle:String, customMessage: String){
        //FAILED LOGIN ALERT
        let failedLoginAlert = UIAlertController(title: alertTitle, message: customMessage, preferredStyle: .Alert)
        let failedLoginAlertAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        failedLoginAlert.addAction(failedLoginAlertAction)
        self.presentViewController(failedLoginAlert, animated: true) {
            // ...
        }
    }

    
    @IBAction func cartAddButton(sender: AnyObject) {
        print("cart plus")
        let cart = (self.tabBarController as! CustomTabBarController).model
        
        
        let buttonRow = sender.tag
        
        cart.myCart[buttonRow].cant++
        cart.itemCount++
        print("sumando el carro hay " + String(cart.itemCount))

        
        //SUB-TOTAL
        cart.myCart[buttonRow].subTotalLP = cart.myCart[buttonRow].lp *  cart.myCart[buttonRow].cant
        cart.myCart[buttonRow].subTotalPrice = cart.myCart[buttonRow].price *  Double(cart.myCart[buttonRow].cant)
        
        
        //TOTAL PRICE OF PURCHASE
        cart.totalLoyaltyPoints = cart.totalLoyaltyPoints + Double(cart.myCart[buttonRow].lp)
        cart.totalPrice = cart.totalPrice + cart.myCart[buttonRow].price
    
        
        displayCartPriceAndLoyaltyPoints()
        self.do_table_refresh()
        
    }
    
    
    @IBAction func cartRemoveButton(sender: AnyObject) {
        
        let cart = (self.tabBarController as! CustomTabBarController).model
        let buttonRow = sender.tag
    
        cart.myCart[buttonRow].cant--
        cart.itemCount--
        print("restando en el carro hay " + String(cart.itemCount))
        
        //SUB-TOTAL
        cart.myCart[buttonRow].subTotalLP = cart.myCart[buttonRow].lp *  cart.myCart[buttonRow].cant
        cart.myCart[buttonRow].subTotalPrice = cart.myCart[buttonRow].price *  Double(cart.myCart[buttonRow].cant)
        
        //TOTAL PRICE OF PURCHASE
        cart.totalLoyaltyPoints = cart.totalLoyaltyPoints - Double(cart.myCart[buttonRow].lp)
        cart.totalPrice = cart.totalPrice - cart.myCart[buttonRow].price
        
        let qty = cart.myCart[buttonRow].cant
        let id = cart.myCart[buttonRow].id
        
        cart.foodId_QtityDict.removeValueForKey(id)
        
        var count = 0
        for object in cart.myCart{
            if (object.id == id){
                if(qty == 0){  //if the current object has quantity of 0, it deletes it from the cart
                    cart.myCart.removeAtIndex(count)
                    number_of_rows = cart.myCart.count
                    tableView.reloadData()
                    print("this is my cart after removing an item")
                    dump(cart.myCart)
                }
            }
            count++
        }

        displayCartPriceAndLoyaltyPoints()
        self.do_table_refresh()
    }
    
    
    
    func displayCartPriceAndLoyaltyPoints(){
        
        let cart = (self.tabBarController as! CustomTabBarController).model
        

        if cart.itemCount == 0{
            totalPriceLabel.hidden = true
            processOrderButton.hidden = true
            orderWarningLabel.hidden = true
            totalLoyaltyLabel.text = "Your cart is empty!"
        }else{
            totalPriceLabel.hidden = false
            processOrderButton.hidden = false
            orderWarningLabel.hidden = false
            
            var itemsString = " items"
            if cart.itemCount < 1{
                itemsString = " item"
            }
        
        
            //creating the attributes to highlight the price
            var multipleAttributes = [String : NSObject]()
            //brown color for the price, and also bolded in size 17
            multipleAttributes[NSForegroundColorAttributeName] = UIColor(red: 62/255, green: 39/255, blue: 35/255, alpha: 1)
            multipleAttributes[NSFontAttributeName] = UIFont.boldSystemFontOfSize(17)
            
            let value: Double = cart.totalPrice
            let unit: String = " ₩"
            
            let finalPriceString = String.localizedStringWithFormat("%@%.0f ", value, unit)
            let attrString3 = NSMutableAttributedString(string: finalPriceString , attributes: multipleAttributes)
            let itemCountString = "Cart Total (" + String(cart.itemCount) + itemsString + "): "
            let AttributedItemCountString = NSMutableAttributedString(string: itemCountString)
            
            totalPriceLabel.attributedText = AttributedItemCountString  + attrString3
            
            //write loyalty points to label
            totalLoyaltyLabel.text = "With this order you will earn " +  String(format:"%.0f", cart.totalLoyaltyPoints) + " Loyalty Points!"
            
        }

    }
    
    
    
    
    
    
    



}
