//
//  RestaurantTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 08/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    //HIDES THE STATUS BAR
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    
    var foods:[Food] = [
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false),
        Food(name: "Pizza", description: "This food is quite yummy indeed and that is why all the customers like it and you will like it as well", price: 15.000, loyaltyPoints: 100 , image: "barrafina.jpg", isLiked: false),
        Food(name: "Moccha", description: "Chocolaty goodness using the best cocoa in the world like the ones from South America", price: 8.000, loyaltyPoints: 800, image: "cafedeadend.jpg", isLiked: false)
    ]

    
    var foodThumbnailsx = ["barrafina.jpg", "bourkestreetbakery.jpg", "cafedeadend.jpg", "cafeloisl.jpg", "cafelore.jpg", "confessional.jpg", "donostia.jpg", "fiveleaves.jpg", "forkeerestaurant.jpg", "grahamavenuemeats.jpg", "haighschocolate.jpg", "homei.jpg", "palominoespresso.jpg", "petiteoyster.jpg", "posatelier.jpg", "royaloak.jpg", "teakha.jpg", "thaicafe.jpg", "traif.jpg"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Self sizing cells (useful for lengthy texts and such
            tableView.estimatedRowHeight = 36.0
            tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
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


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = foods[indexPath.row].name
        cell.thumbnailImageView.image = UIImage(named: foods[indexPath.row].image)
        cell.descriptionLabel.text = foods[indexPath.row].description
        cell.priceLabel.text = String(foods[indexPath.row].price)
        
        if foods[indexPath.row].isLiked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        //Create an option menu as action sheet
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do", preferredStyle: .ActionSheet)
//        
//        // Add actions to the menu
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        let callActionHandler = { (action:UIAlertAction)-> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, call feature is not available yet. Please, try later.", preferredStyle: .Alert)
//        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertMessage, animated: true, completion: nil)}
//        
//        
//        let callAction = UIAlertAction(title: "Call" + "123-000-13341", style: UIAlertActionStyle.Default , handler: callActionHandler)
//        
//        var isVisitedTitle = ""
//        if foodsLiked[indexPath.row] {
//            isVisitedTitle = "I don't like this"
//        }else {
//            isVisitedTitle = "I like this food"
//        }
//        
//        let isVisitedAction = UIAlertAction(title: isVisitedTitle, style: .Default, handler: {
//            (action: UIAlertAction!) -> Void in
//            
//            let cell = tableView.cellForRowAtIndexPath(indexPath)
//            
//            if self.foodsLiked[indexPath.row]{
//                cell?.accessoryType = .None
//                self.foodsLiked[indexPath.row] = false
//            }else{
//                cell?.accessoryType = .Checkmark
//                self.foodsLiked[indexPath.row] = true
//            }
//            
//            
//        })
//        
//        
//        //adding the actions to the menu
//        optionMenu.addAction(isVisitedAction)
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(cancelAction)
//        
//        
//        //display the menu
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFoodDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! FoodDetailViewController
                destinationController.food = foods[indexPath.row]
            }
        }
    }


}
