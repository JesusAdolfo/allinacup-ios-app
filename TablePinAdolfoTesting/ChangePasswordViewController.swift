//
//  ChangePasswordViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 13/03/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

    @IBOutlet var currentPasswordTxtField: UITextField!
    @IBOutlet var newPasswordTxtField: UITextField!
    @IBOutlet var confirmNewPasswordTxtField: UITextField!
    @IBOutlet var changeButton: UIButton!
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let CHANGE_PASSWORD_ENDPOINT = "/api/users/password"
    let userDefaults = NSUserDefaults.standardUserDefaults() // create userDefaults to load token

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePasswordPressed(sender: AnyObject) {
        let currentPassword = currentPasswordTxtField.text
        let newPassword = newPasswordTxtField.text
        let confirmPassword = confirmNewPasswordTxtField.text
        
        if(currentPassword == "" || newPassword == "" || confirmPassword == ""){
            self.alert("Complete all the fields", customMessage: "Please, complete the required information")
        }else if(newPassword != confirmPassword){
            self.alert("New password", customMessage: "The new password and its confirmation do not match")
        }else if(newPassword == confirmPassword){
            if let myToken = userDefaults.valueForKey("token"){
                let requestToken = "Bearer " + (myToken as! String)
                let headers = ["Authorization": requestToken,
                                "Content-Type": "application/x-www-form-urlencoded"]
                
                let parameters:[String: AnyObject!] = [
                    "oldPassword": currentPassword,
                    "newPassword": newPassword
                ]
                
                
                let changePassEndpoint: String = BASE_URL + CHANGE_PASSWORD_ENDPOINT
                
                
                Alamofire.request(.PUT, changePassEndpoint, headers: headers, parameters: parameters)
                    .responseJSON{ response in
                        
                            let statusCode = response.response?.statusCode
                            var message = ""
                            var title = ""
                            print("-->", statusCode)
                            if(statusCode==403){
                                title = "Wrong password?"
                                message = "That is not your current password"
                                print(statusCode)
                                self.alert(title, customMessage: message)

                            }else if(statusCode==200 || statusCode==201){
                                print("password was changed")
                                self.alert("Success", customMessage: "Your password has been changed successfully")
                            }else{
                                title = "Check your internet connection"
                                message = "Please, check your internete connection"
                                print(statusCode)
                                self.alert(title, customMessage: message)
                            }
                            
                        
                }//END ALAMOFIRE POST responseJSON
            }
        }
    }
    func changePassword(){
        
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
    
    func alertWithSegue(alertTitle:String, customMessage: String, segueIdentifier: String){
        //FAILED LOGIN ALERT
        let failedLoginAlert = UIAlertController(title: alertTitle, message: customMessage, preferredStyle: .Alert)
        let failedLoginAlertAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier(segueIdentifier, sender: nil)
            
        }
        failedLoginAlert.addAction(failedLoginAlertAction)
        self.presentViewController(failedLoginAlert, animated: true) {
            // ...
        }
    }

   

}
