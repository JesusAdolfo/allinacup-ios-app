//
//  FoodDetailViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 10/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var foodImageView:UIImageView!
    
    var food:Food!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foodImageView.image = UIImage(named: food.image) //assign the image in the detail
        
        //CHANGING THE COLOR OF THE DETAIL BACKGROUND
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 2.0)
        //REMOVING THE BOTTOM BORDER FROM THE CELLS
        tableView.tableFooterView = UIView(frame: CGRectZero)
        //Changes Separator for Content Rows
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // set the current food as the title in the navigation bar
        title = food.name
        
        //Self sizing cells (useful for lengthy texts and such
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell",
                forIndexPath: indexPath) as! FoodDetailTableViewCell
            // Configure the cell...
            switch indexPath.row {
            case 0:
                cell.fieldLabel.text = "Dish"
                cell.valueLabel.text = food.name
            case 1:
                cell.fieldLabel.text = "Description"
                cell.valueLabel.text = food.description
            case 2:
                cell.fieldLabel.text = "Price"
                cell.valueLabel.text = String(food.price) + " ₩"
            case 3:
                cell.fieldLabel.text = "Loyalty Points"
                cell.valueLabel.text = String(food.loyaltyPoints) + " LP"
            case 4:
                cell.fieldLabel.text = "You liked it?"
                cell.valueLabel.text = (food.isLiked) ? "Yes" : "No"
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            
            cell.backgroundColor = UIColor.clearColor()
            return cell
    }


}
