//
//  CustomTableViewCell.swift
//  Scalr
//
//  Created by Michael Heft on 2/5/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
