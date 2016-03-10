//
//  SocketIOManager.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 02/03/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import SwiftyJSON

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://159.203.92.55:9000")!)
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var nickname: String!
    
    override init() {
        super.init()
    }

    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
        if let email = self.userDefaults.valueForKey("email"){
            let jsonObject: [String: AnyObject] = [
                "nickName": nickname,
                "username": email
            ]
            socket.emit("init chat", jsonObject);
            socket.emit("connected users", email)
        }
        socket.on("users") {( dataArray, ack) -> Void in
            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
        }
        
        listenForOtherMessages()
    }
    
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    
    func sendMessage(message: String, withNickname nickname: String) {
        
        if let email = self.userDefaults.valueForKey("email"){
            let jsonObject: [String: AnyObject] = [
                "username": email,
                "nickName": nickname,
                "message": message
            ]
            print(jsonObject)
            socket.emit("send message", jsonObject)
        }

    }
    
    
    func getChatMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("new message") { (dataArray, socketAck) -> Void in
            print("someone sent a message")
            let myJSON = JSON(dataArray)
            let message = myJSON[0]["message"].stringValue
            print("el mensaje fue" , message)
            
            var messageDictionary = [String: AnyObject]()
            messageDictionary["message"] = myJSON[0]["message"].stringValue
            messageDictionary["nickName"] = myJSON[0]["nickName"].stringValue
            messageDictionary["username"] = myJSON[0]["username"].stringValue
            
            completionHandler(messageInfo: messageDictionary)
        }
    }
    
    
    private func listenForOtherMessages() {
        
        //new user connected
        socket.on("new user"){ (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasConnectedNotification", object: dataArray[0] as? [String: AnyObject])
            print(dataArray[0] as? [String: AnyObject])
            print("new user connected")
        }

        socket.on("user disconnected"){ (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasDisconnectedNotification", object: dataArray[0] as? [String: AnyObject])
            print(dataArray[0] as? [String: AnyObject])
            print("new user disconnected")
        }

        

    }

}
