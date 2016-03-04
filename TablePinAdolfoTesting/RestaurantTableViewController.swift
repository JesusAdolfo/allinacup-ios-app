//
//  RestaurantTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 08/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class RestaurantTableViewController: UITableViewController {
    
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    
    let PRODUCT_TYPES: String = "/api/products/getTypes"
    let USER_INFO: String = "/api/users/me"
    let PRODUCT_BY_TYPE: String = "/api/products/byType/"
    let IMAGE_ROOT = "/api/media/image?path="
    
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token
    

    var foods:[Food] = []
    var user:[User] = []



    ///This method is called when this view loads (Duh!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        var currentFoodType: String = ""
        var currentFoodList: String = ""
        
        
        //creating an empty cart when the app launches
        var cart = (self.tabBarController as! CustomTabBarController).model

        //this is how I get back the token from NSUserDefault
        if let myToken = userDefaults.valueForKey("token"){
            
            
            // calling method to get the user info
            getUserInfo(myToken as! String)

            // calling method to get the product type
            func getFoodCategory(completionHandler: (NSDictionary?, NSError?) -> ()) {
                getProductTypes(myToken as! String, completionHandler: completionHandler)
            }
            getFoodCategory() { responseObject, error in
                // use responseObject and error here
                
                let foodTypesJSON = JSON(responseObject!)
                //to get one single food category
                currentFoodType = (foodTypesJSON["types"][self.tabBarController!.selectedIndex].stringValue) //gets the FOOD category according to which tab was selected
                
                    func getFoodsByCategory(completionHandler: (NSDictionary?, NSError?) -> ()) {
                        self.getProductsByType(myToken as! String, productType: currentFoodType, completionHandler: completionHandler)
                    }
                    
                    getFoodsByCategory() { responseObject, error in
                        // use responseObject and error here
                        print("responseObject = \(responseObject); error = \(error)")
                        
                        return
                    }

                
               return
            }
            
        }
        
        
        
        //remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Self sizing cells (useful for lengthy texts and such
            tableView.estimatedRowHeight = 36.0
            tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        
        
        //Refresshes the table everytime a tab appears
        self.do_table_refresh()
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
        return foods.count
    }

    
    
    //GET THE USER INFO FROM THE SERVER
    func getUserInfo(myToken: String){
        
        let requestToken = "Bearer " + myToken
        
        let headers = [
            "Authorization": requestToken
        ]
        
        let getUserInfoEndpoint: String = BASE_URL + USER_INFO
    

        
        
        Alamofire.request(.GET, getUserInfoEndpoint, headers: headers)
            .responseJSON { response in
                // handle JSON
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error on GET")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let auth = JSON(value)
                    
                    let id = auth["_id"].int
                    
                    let cart = (self.tabBarController as! CustomTabBarController).model
                    cart.idUser = id!
                    
                    let address = auth["address"].stringValue
                    let role = auth["role"].stringValue
                    let lvl = auth["lvl"].int
                    let lastName = auth["lastName"].stringValue
                    let gender = auth["gender"].stringValue
                    let loyaltyPoints = auth["loyaltyPoints"].double
                    let firstName = auth["firstName"].stringValue
                    let phoneNumber = auth["phoneNumber"].stringValue
                    let email = auth["email"].stringValue
                    
                    let currentUser = User(_id: id!, address: address, role: role, lvl: lvl!, lastName: lastName, gender: gender, loyaltyPoints: loyaltyPoints!, firstName: firstName, phoneNumber: phoneNumber, email: email)
                    
                    self.user.removeAll()
                    self.user.append(currentUser)
                    //auth
                    

                }
        }//END ALAMOFIRE POST responseJSON
    }
    
    
    
    
    //GET THE PRODUCT TYPES FROM THE SERVER
    func getProductTypes(myToken: String, completionHandler: (NSDictionary?, NSError?) -> ())  {
        
        let requestToken = "Bearer " + myToken
        let headers = ["Authorization": requestToken]
        let getProductTypesEndpoint: String = BASE_URL + PRODUCT_TYPES
 
        
        Alamofire.request(.GET, getProductTypesEndpoint, headers: headers)
            .responseJSON{ response in
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? NSDictionary, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
        }//END ALAMOFIRE POST responseJSON
        

    }
    
    //GET THE PRODUCTS FROM THE SERVER GIVEN A CATEGORY
    func getProductsByType(myToken: String, productType: String, completionHandler: (NSDictionary?, NSError?) -> ()){
        
        let requestToken = "Bearer " + myToken
        let headers = ["Authorization": requestToken]
        let getProductTypesEndpoint: String = BASE_URL + PRODUCT_BY_TYPE + productType
        
        Alamofire.request(.GET, getProductTypesEndpoint, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let foodListJSON = JSON(value)
                        for (_, subJson) in foodListJSON {
                            
                            let id = subJson["_id"].stringValue
                            let name = subJson["name"].stringValue
                            let description = subJson["description"].stringValue
                            let  price = subJson["price"].double
                            let loyaltyPoints = subJson["loyaltyPoints"].int
                            
                            let loadedFood = Food(id: id, name: name, description: description, price: price!, loyaltyPoints: loyaltyPoints!, image: self.BASE_URL + self.IMAGE_ROOT + subJson["image"].stringValue, isLiked: true)
                            self.foods.append(loadedFood)
                            
                            self.do_table_refresh()
            
                        }
                    }

                case .Failure(let error):
                    print("there was an error")

                    completionHandler(nil, error)
                }
        }//END ALAMOFIRE POST responseJSON
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.addButton.tag = indexPath.row
        
        //disable cell highlighting
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Configure the cell...
        cell.nameLabel.text = foods[indexPath.row].name
        
        
        if let myToken = userDefaults.valueForKey("token"){
            let requestToken = "Bearer " + (myToken as! String)
            let headers = ["Authorization": requestToken, "Content-Type": "image/jpg"]
            let imageEndPoint = foods[indexPath.row].image
            
            let imageId = "image_" + String(foods[indexPath.row].id)
            
            //MATCHING THE SERVER RESPONSE TO THE RESPONSE ACCEPTED BY ALAMOFIREIMAGE
            Request.addAcceptableImageContentTypes(["image/jpg"])
            
            
            
            let imageCache = AutoPurgingImageCache()
            
            let URLRequest = NSURLRequest(URL: NSURL(string: imageEndPoint)!)
            
            Alamofire.request(.GET, imageEndPoint, headers: headers)
                .responseImage { response in
                    
                    if let image = response.result.value {
                        cell.thumbnailImageView.image = image
                        imageCache.addImage(
                            image,
                            forRequest: URLRequest,
                            withAdditionalIdentifier: imageId
                        )
                        
                    }
            }//ENDS ALAMOFIREIMAGE REQUEST
            
            
        }

        
        cell.descriptionLabel.text = foods[indexPath.row].description
        
        let priceValue: Double = foods[indexPath.row].price
        let unit: String = " ₩"
        let priceString = String.localizedStringWithFormat("%@%.0f ", priceValue, unit)
        
        cell.priceLabel.text = priceString
        cell.loyaltyLabel.text = "LP: " + String(foods[indexPath.row].loyaltyPoints)
        
        return cell
    }

    
    //SHARE AND DELETE FROM THE TABLE LIST
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //social sharing button
        let shareAction = UITableViewRowAction(style: .Default , title: "Share", handler: {
            (action, indexPath)-> Void in
            
            let defaultText = "I really like this " + self.foods[indexPath.row].name + " that I had at \"All in a Cup\" Restaurant"
            
            if let imageToShare = UIImage(named: self.foods[indexPath.row].image){
                let activityController = UIActivityViewController(activityItems: [defaultText,imageToShare], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)

            }
           
            
        })
        
        //delete button
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {
            (action,indexPath) -> Void in
            //Delete the row from the data source            
            self.foods.removeAtIndex(indexPath.row)

            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        })
        
        //adding color to the swipe options
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    
    
    //FIXME: animation is funky
    @IBAction func addButtonClicked(sender: AnyObject) {
        
        let cartx = (self.tabBarController as! CustomTabBarController)
        cartx.animateCart()
        //Animation the button when clicked
        let button = sender as! UIButton
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1 , options: .CurveEaseInOut, animations: { () -> Void in
            
            
            
            button.tintColor = UIColor.grayColor()
            
            
            //TODO: I have to do this
            
            //set background to brown
            //button.backgroundColor = UIColor(red: 62/255, green: 39/255, blue: 35/255, alpha: 1)
            //set + sign to gray
            //button.setBackgroundImage(a, forState: <#T##UIControlState#>)
            
            button.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { (t) -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
              //  button.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 35.0/255.0, alpha: 1.0)
           })
        
        //end of the code regarding the animation
        
        let buttonRow = sender.tag
        
        foods[buttonRow].qtity++
        
        foods[buttonRow].totalLP = foods[buttonRow].loyaltyPoints * foods[buttonRow].qtity
        foods[buttonRow].totalPrice = foods[buttonRow].price * Double(foods[buttonRow].qtity)
        
        let cart = (self.tabBarController as! CustomTabBarController).model
        
        cart.itemCount++
        
        //adds to the total of the cart
        cart.totalLoyaltyPoints = cart.totalLoyaltyPoints + Double(foods[buttonRow].loyaltyPoints)
        cart.totalPrice = cart.totalPrice + foods[buttonRow].price
        
        
        //fields to create a new item in the cart.
        let id = foods[buttonRow].id
        let name = foods[buttonRow].name
        let description = foods[buttonRow].description
        let price = foods[buttonRow].price
        let lp = foods[buttonRow].loyaltyPoints
        let image = foods[buttonRow].image

        let qty = foods[buttonRow].qtity
        if let _ = cart.foodId_QtityDict[id] {
            cart.foodId_QtityDict.updateValue(qty, forKey: id)
            
            //adds to the sub-total of the current item
            //adds 1 to an item existing in the cart
            for object in cart.myCart{
                if (object.id == id){
                    object.cant += 1
                    object.subTotalLP += lp
                    object.subTotalPrice += price
                }
            }
        }else{
            //create new object because this food is not in the cart
            cart.myCart.append(FoodItem(id: id, name: name, cant: 1, description: description, price: price, lp: lp, image: image, subTotalLP: lp, subTotalPrice: price ))
            
            cart.foodId_QtityDict.updateValue(1, forKey: id)
            cart.productNamesDict.updateValue(name, forKey: id)
        }
        self.do_table_refresh()
        
    }


}
