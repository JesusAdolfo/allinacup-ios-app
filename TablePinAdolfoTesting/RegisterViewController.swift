//
//  RegisterViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 27/02/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let BASE_URL: String = "http://159.203.92.55:9000"
    let REGISTER_URL: String = "/api/users/register"

    @IBOutlet var ageLabel: UITextField!
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var lastnameLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var phoneLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var addressLabel: UITextView!
    

    @IBAction func ageChanged(sender: AnyObject) {
        checkMaxLength(ageLabel, maxLength: 2)
    }
    @IBAction func phoneChanged(sender: AnyObject) {
        checkMaxLength(phoneLabel, maxLength: 8)

    }

    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        let age:String = ageLabel.text!
        let gender:String = genderControl.titleForSegmentAtIndex(genderControl.selectedSegmentIndex)!
        let name:String = nameLabel.text!
        let lastname:String = lastnameLabel.text!
        let email:String = emailLabel.text!
        let phone:String = phoneLabel.text!
        let password:String = passwordLabel.text!
        let address:String = addressLabel.text!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters = [
            "age": age,
            "gender": gender,
            "firstName": name,
            "lastName": lastname,
            "email": email,
            "phoneNumber": phone,
            "password": password,
            "address": address
        ]
        
        let registerEndpoint = BASE_URL + REGISTER_URL
        
        if (isValidEmail(email)){
            Alamofire.request(.POST, registerEndpoint, headers: headers, parameters: parameters)
                .validate()
                .responseJSON{ response in
                    switch response.result {
                    case .Success(let value):
                        let myJSON = JSON(value)
                        print(myJSON)
                        self.alertWithSegue("Success", customMessage: "Your account was created successfully", segueIdentifier: "register_ended")
                        
                    case .Failure:
                        let statusCode = response.response?.statusCode
                        var message = ""
                        var title = ""
                        if(statusCode==409){
                            title = "Email taken"
                            message = "That email is already registered, try recovering your password or register with another email"
                            print("the code is 409")
                        }else{
                            title = "Connection error"
                            message = "Check your internet connection"
                            print(statusCode)
                            print("it is 400")
                        }

                        self.alert(title, customMessage: message)
                    }
            }//END ALAMOFIRE POST REQUEST
        }else{
            alert("Error", customMessage: "The email that you entered is invalid")
        }
        //dump(parameters)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageLabel.delegate = self
        phoneLabel.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        if let _ = string.rangeOfCharacterFromSet(invalidCharacters, options: [], range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
            return false
        }
        
        return true
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
