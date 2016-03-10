//
//  LoyaltyViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 05/02/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class LoyaltyViewController: UITableViewController {
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let LEVELS_URL: String = "/api/loyalty-program"
    let USER_INFO: String = "/api/users/me"

    @IBOutlet var yourLevelLbl: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token
    
    var levels:[Levels] = []
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        getLevels()
        print(levels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }

    
    func getLevels(){
        if let myToken = userDefaults.valueForKey("token"){
            let requestToken = "Bearer " + (myToken as! String)
            let headers = ["Authorization": requestToken]
            let getLevelsEndpoint: String = BASE_URL + LEVELS_URL
            
            
            Alamofire.request(.GET, getLevelsEndpoint, headers: headers)
                .responseJSON{ response in
                    switch response.result {
                    case .Success(let value):
                        let levelsJSON  = JSON(value)
                        for (_, subJson) in levelsJSON {
                            
                            let lvl = subJson["lvl"].int
                            let points = subJson["points"].int
                            let color = subJson["color"].stringValue
                            
                            let levelItem = Levels(lvl: lvl!, points: points!, color: color)
                            
                            dump(levelItem)
                            self.levels.append(levelItem)
                            self.do_table_refresh()

                        }
                        
                        
                    case .Failure(let error):
                        
                        print(error)
                        self.alert("Error contacting the server", customMessage: "Please, check your internet connection")
                    }
            }//END ALAMOFIRE POST responseJSON
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LevelTableViewCell
        
        
        //disable cell highlighting
        cell.selectionStyle = .None
        
        // Configure the cell...
        let cellLevel:Int = levels[indexPath.row].lvl
        let cellExp:Float = Float(levels[indexPath.row].points)
        let cellExpString:String = String(Int(cellExp))
        let progressBarColor:String = levels[indexPath.row].color
        
        let functions = Functions()

        
        if let _ = userDefaults.valueForKey("token"){
            functions.getUserLP({ responseObject, error in
                // use responseObject and error here
                let userDataJSON = JSON(responseObject!)

                let currentExp:Float = userDataJSON["loyaltyPoints"].floatValue
                let currentExpString:String = String(Int(currentExp))
                let currentLvl:Int = userDataJSON["lvl"].int!
                
                self.yourLevelLbl.text = "You're a level \(currentLvl) \n Level up and earn rewards!"
                
                print("cell", indexPath.row, "exp", currentExp, "lvl", currentLvl, "%",(currentExp/cellExp))
                
                if (currentLvl == cellLevel){
                    cell.expLabel.text = currentExpString + "/" + cellExpString
                    cell.lvlProgressBar.setProgress(Float(0.10 + currentExp/cellExp)  , animated: false)
                    cell.backgroundColor = UIColor.grayColor()
                }else if (currentLvl > cellLevel){
                    cell.expLabel.text = cellExpString + "/" + cellExpString
                    cell.lvlProgressBar.setProgress(1.00, animated: false)
                }else{
                    cell.lvlProgressBar.setProgress(0.10, animated: false)
                    cell.expLabel.text = "0/" + cellExpString
                }
                
                return
            })
            
        }
        
        
        cell.levelLabel.text = String(cellLevel)
        cell.levelLabel.layer.cornerRadius = 15
        cell.lvlProgressBar.layer.cornerRadius = 15
        cell.lvlProgressBar.progressTintColor = (functions.colorWithHexString(progressBarColor))
        cell.lvlProgressBar.trackTintColor = (functions.colorWithHexString("#DDDDDD"))
        return cell
    }
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
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
    
    

}
