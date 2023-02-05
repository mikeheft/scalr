//
//  CustomTableViewCell.swift
//  Scalr
//
//  Created by Michael Heft on 2/5/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var ingredients: [Ingredient] = []
    var indexPath: IndexPath?
    var tableView: UITableView?


    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
//        ingredients.remove(at: indexPath?.row ?? 0)
//        tableView?.deleteRows(at: [indexPath ?? IndexPath(row: 0, section: 0)], with: .automatic)
//        print("CUSTOM = \(ingredients)")
//        ViewController.setValue(ingredients, forKey: "updatedIngredients")
//        self.removeFromSuperview()
    }
}
