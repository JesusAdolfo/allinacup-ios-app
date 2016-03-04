//
//  LoginVC.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 06/01/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {

    
    @IBOutlet var logoTextLabel: UILabel!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var facebookLogInButton: UIButton!
    
    @IBOutlet var forgotLabel: UILabel!
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
    
    var user_token: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("token")
        userDefaults.synchronize()
        txtLoginEmail.center.x  -= view.bounds.width
        txtLoginPassword.center.x -= view.bounds.width
        logoTextLabel.center.x -= view.bounds.width
        facebookLogInButton.center.x -= view.bounds.width
        logInButton.center.x -= view.bounds.width
        forgotLabel.center.x -= view.bounds.width
        registerButton.center.x -= view.bounds.width
        
        
        UIView.animateWithDuration(0.5, delay: 0.4,
            options: [.CurveEaseInOut],
            animations: {
            self.txtLoginEmail.center.x += self.view.bounds.width
            self.txtLoginPassword.center.x += self.view.bounds.width
            self.logoTextLabel.center.x += self.view.bounds.width
            self.logInButton.center.x += self.view.bounds.width
            self.facebookLogInButton.center.x += self.view.bounds.width
            self.forgotLabel.center.x += self.view.bounds.width
            self.registerButton.center.x += self.view.bounds.width
            
            
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Regular authentication code
    @IBAction func normalLogin(sender: UIButton) {
        
        
        if ( txtLoginEmail.text == "" || txtLoginPassword == "" )
        {
            let alertController = UIAlertController(title: "Error", message: "Please, Enter email and password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        else
        {
            let email:NSString = txtLoginEmail.text!
            let password:NSString = txtLoginPassword.text!

            let headers = [
                "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let loginEndpoint: String = "http://159.203.92.55:9000/auth/local/app"
            
            let parameters = [
                "email": email,
                "password": password

            ]
            
            
            
            Alamofire.request(.POST, loginEndpoint, headers: headers, parameters: parameters)
                .responseJSON { response in
                    // handle JSON
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("Error in Post at LoginEndPoint")
                        print(response.result.error!)
                        
                        let message = "Error establishing connection. Check your Internet Connection."
                        
                        self.alert(message)
                        
                        return
                    }
                    
                    if let value: AnyObject = response.result.value {
                        // handle the results as JSON, without a bunch of nested if loops
                        let auth = JSON(value)
                        
                        
                        //HANDLE SUCCESSFUL LOGIN (if token is found)
                        if let token = auth["token"].string{
                            
                            
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setValue(token, forKey: "token")
                            userDefaults.synchronize()
                            
                            
                            
                            self.performSegueWithIdentifier("home_screen", sender: self.user_token)
                            
                            
                            
                        }else{
                            //HANDLE FAILED LOGIN IF NO TOKEN WAS FOUND
                            if let message = auth["message"].string{
                                print(message)
                                
                                self.alert(message)
                                
                            }
                        }
                    }
                }.responseString{ response in
                    // print response as string for debugging, testing, etc.
//                    print("")
//                    print("")
//                    print(response.result.value)
//                    print(response.result.error)
            }//END ALAMOFIRE POST responseJSON
            
        } //END ELSE
    }//END normalLogin FUNC
    
 
    
    func alert(customMessage: String){
        //FAILED LOGIN ALERT
        let failedLoginAlert = UIAlertController(title: "Error", message: customMessage, preferredStyle: .Alert)
        let failedLoginAlertAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        failedLoginAlert.addAction(failedLoginAlertAction)
        self.presentViewController(failedLoginAlert, animated: true) {
            // ...
        }
    }
    

}//class ends
