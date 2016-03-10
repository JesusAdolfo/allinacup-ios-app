//
//  ChatTableViewController.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 07/02/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate  {

    @IBOutlet var tblChat: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var tvMessageEditor: UITextView!
    @IBOutlet weak var lblNewsBanner: UILabel!
    var bannerLabelTimer: NSTimer!
    @IBOutlet var connectedUsersLabel: UILabel!
    var connectedUsersCounter: Int!
    //whatever I will receive from the server
    var users = [[String: AnyObject]]()
    var nickname: String!
    //Array of dictionaries containing the messages
    var chatMessages = [[String: AnyObject]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fixes issue with the textview
        self.automaticallyAdjustsScrollViewInsets = false
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleConnectedUserUpdateNotification:", name: "userWasConnectedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: "userWasDisconnectedNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        configureNewsBannerLabel()
        tvMessageEditor.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //asks for nickname forever unless you enter one
        if nickname == nil {
            askForNickname()
        }
        
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.chatMessages.append(messageInfo)
                self.tblChat.reloadData()
            })
        }
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        if tvMessageEditor.text.characters.count > 0 {
            SocketIOManager.sharedInstance.sendMessage(tvMessageEditor.text!, withNickname: nickname)
            
            var messageDictionary = [String: AnyObject]()
            messageDictionary["message"] = tvMessageEditor.text!
            messageDictionary["nickName"] = nickname
            self.chatMessages.append(messageDictionary)
            self.tblChat.reloadData() //reload table after I send my message
            tvMessageEditor.text = ""
            
            //to hide the keyboard
            tvMessageEditor.resignFirstResponder()
        }
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func askForNickname() {
        let alertController = UIAlertController(title: "Nickname", message: "Please enter a nickname:", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler(nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.characters.count == 0 {
                self.askForNickname()
            }
            else {
                self.nickname = textfield.text
                SocketIOManager.sharedInstance.connectToServerWithNickname(self.nickname, completionHandler: { (userList) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if userList != nil {
                            self.users = userList
                            self.connectedUsersCounter = userList.count
                            self.connectedUsersLabel.text = "Participants: " + String(self.connectedUsersCounter)
                        }
                    })
                })
            }
        }
        
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickName"] as? String
        lblNewsBanner.text = "User \(connectedUserNickname!.uppercaseString) connected."
        self.connectedUsersCounter = self.connectedUsersCounter + 1
        self.connectedUsersLabel.text = "Participants: " + String(self.connectedUsersCounter)
        showBannerLabelAnimated()
    }
    
    func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserInfo = notification.object as! [String: AnyObject]
        let disconnectedUserNickname = disconnectedUserInfo["nickName"] as? String
        lblNewsBanner.text = "User \(disconnectedUserNickname!.uppercaseString) has left."
        self.connectedUsersCounter = self.connectedUsersCounter - 1
        self.connectedUsersLabel.text = "Participants: " + String(self.connectedUsersCounter)
        showBannerLabelAnimated()
    }
    
    func showBannerLabelAnimated() {
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
            
            }) { (finished) -> Void in
                self.bannerLabelTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideBannerLabel", userInfo: nil, repeats: false)
        }
    }
    
    
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
            
            }) { (finished) -> Void in
        }
    }
    
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 10.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }

    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.registerNib(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 90.0
        tblChat.separatorStyle = UITableViewCellSeparatorStyle.None
        tblChat.rowHeight = UITableViewAutomaticDimension
        
        //with this line we reverse the table
        tblChat.transform = CGAffineTransformMakeScale(1, -1)
        tblChat.tableFooterView = UIView(frame: CGRectZero)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellChat", forIndexPath: indexPath) as! ChatCell
        
        var reversedChatMessages: [[String: AnyObject]] = chatMessages.reverse()
        
        let currentChatMessage = reversedChatMessages[indexPath.row]
        let senderNickname = currentChatMessage["nickName"] as! String
        let message = currentChatMessage["message"] as! String
        
        
        if senderNickname == nickname {
            //When the cell and message belong to you
            cell.lblChatMessage.textAlignment = NSTextAlignment.Right
            cell.lblMessageDetails.textAlignment = NSTextAlignment.Right
            cell.lblMessageDetails.text = "\(senderNickname) (You)"
        }else{
            //When the cell and message is from other users
            cell.lblMessageDetails.text = "\(senderNickname)"
            cell.bubbleView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0) /* #ededed */
            cell.bubbleViewLeftMargin.constant = 0
            cell.bubbleViewRightMargin.constant = 100
        }
        
        //with this line we reverse the cell
        cell.transform = CGAffineTransformMakeScale(1, -1);

        
        cell.lblChatMessage.text = message
        return cell
    }
    

}
