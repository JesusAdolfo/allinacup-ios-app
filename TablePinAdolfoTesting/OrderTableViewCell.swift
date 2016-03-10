//
//  OrderTableViewCell.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 03/03/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var totalLpLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var processedLabel: UILabel!
    @IBOutlet var productListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
