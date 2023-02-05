//
//  CustomScaledTableViewCell.swift
//  Scalr
//
//  Created by Michael Heft on 2/5/23.
//

import UIKit

class CustomScaledTableViewCell: UITableViewCell {

    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ouncesLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
