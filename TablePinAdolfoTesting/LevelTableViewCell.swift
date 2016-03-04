//
//  LevelTableViewCell.swift
//  TablePinAdolfoTesting
//
//  Created by Jesus Adolfo on 23/02/16.
//  Copyright © 2016 Jesus Adolfo. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var expLabel: UILabel!
    @IBOutlet var lvlProgressBar: UIProgressView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.levelLabel.text = ""
        self.expLabel.text = ""
        self.lvlProgressBar.progress = 0
        self.lvlProgressBar.setProgress(0.01, animated: true)
    }

}
