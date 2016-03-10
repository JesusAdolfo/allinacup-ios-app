//
//  ChatCell.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ChatCell: BaseCell {

    @IBOutlet weak var lblChatMessage: UILabel!
    @IBOutlet weak var lblMessageDetails: UILabel!
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var bubbleViewLeftMargin: NSLayoutConstraint!
    
    @IBOutlet var bubbleViewRightMargin: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        bubbleViewRightMargin.constant = 0
        bubbleViewLeftMargin.constant = 100
        bubbleView.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 35/255, alpha: 1)
        lblChatMessage.textAlignment = NSTextAlignment.Left
        lblMessageDetails.textAlignment = NSTextAlignment.Left
    }

}
