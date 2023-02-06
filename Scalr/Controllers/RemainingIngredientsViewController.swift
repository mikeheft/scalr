//
//  RemainingIngredientsViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/4/23.
//

import UIKit

class RemainingIngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ounces: UITextField!
    @IBOutlet weak var pounds: UITextField!
    
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        
        self.registerTableViewCells()
    }
    
    @IBAction func addRemainingIngredientButtonPressed(_ sender: AnyObject) {
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
        addRemainingIngredients(lbs: lbs, oz: oz, name: name)

        pounds.text = ""
        ounces.text = ""
        ingredientName.text = ""
        
        self.view.endEditing(true)
        ingredientTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flourIngredients.count + remainingIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let combinedIngredients = flourIngredients + remainingIngredients
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        if row < flourIngredients.count {
            cell.cancelButton.isHidden = true
        }
        
        cell.textLabel?.text = combinedIngredients[row].formatted()
        
        return cell
    }
    
    func addRemainingIngredients(lbs: String?, oz: String?, name: String?) {
        let oz = oz == "" ? "0" : oz
        let lbs = lbs == "" ? "0" : lbs
        let ingredient = Ingredient(name: name!,pounds: Int(lbs!)!, ounces: Float(oz!)!)
        
        remainingIngredients.append(ingredient)
    }
    
    func alertController(_ title: String, _ localizedString: String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString(localizedString, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        return alertController
    }
    
    @IBAction func primaryActionTriggered(_ sender: UITextField) {
        addRemainingIngredientButtonPressed(sender)
        self.view.endEditing(true)
    }
    
    @IBAction func scalePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToScale", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToScale" {
            let destinationVC = segue.destination as! ScaleViewController
            destinationVC.flourIngredients = flourIngredients
            destinationVC.remainingIngredients = remainingIngredients
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.ingredientTable.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

}
