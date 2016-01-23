//
//  MenuTableViewCell.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 12/12/15.
//  Copyright © 2015 Jesus Adolfo. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var loyaltyLabel: UILabel!
    
    @IBOutlet var qtyLabel: UILabel!
    @IBOutlet var loyaltyPointsLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!

    override func awakeFromNib() {
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
