//
//  ViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var addRemainingIngrediensButton: UIButton!
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var ounces: UITextField!
    @IBOutlet weak var pounds: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    
    var ingredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
    }

    @IBAction func addIngredientBtnPressed(_ sender: AnyObject) {
        let lbs = pounds.text
        let oz = ounces.text
        let name = ingredientName.text
        var alert: UIAlertController
        
        if name == "" {
            alert = alertController("You have to provide a name for this ingredient")
            self.present(alert, animated: true, completion: nil)
            return
        }
        if oz == "" && lbs == "" {
            alert = alertController("You must at least add some ounces")
            self.present(alert, animated: true, completion: nil)
            return
        }
        addIngredient(lbs: lbs, oz: oz, name: name)

        pounds.text = ""
        ounces.text = ""
        ingredientName.text = ""
        ingredientTable.reloadData()
    }
    
    func addIngredient(lbs: String?, oz: String?, name: String?) {
        let oz = oz == "" ? "0" : oz
        let lbs = lbs == "" ? "0" : lbs
        let ingredient = Ingredient(pounds: Int(lbs!)!, ounces: Int(oz!)!, name: name!)
        ingredients.append(ingredient)
    }
    
    @IBAction func primaryActionTriggered(_ sender: UITextField) {
        addIngredientBtnPressed(sender)
        self.view.endEditing(true)
    }
    
    func alertController(_ title: String, _ localizedString: String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString(localizedString, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        return alertController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ingredientCount: Int = ingredients.count
        return ingredientCount <= 1 ? 1 : ingredientCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientCount = ingredients.count
        let cell = ingredientTable.dequeueReusableCell(withIdentifier: "amounts", for: indexPath)
        let row = indexPath.row
        
        if row == 0  && ingredientCount == 0 {
            cell.textLabel?.text = "Add Flour(s)"
        } else {
            cell.textLabel?.text = ingredients[row].formatted()
        }
        
        return cell
    }
    
    
}

