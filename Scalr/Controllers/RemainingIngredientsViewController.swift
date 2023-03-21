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
        hideKeyboardWhenTappedAround()
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
    
    @objc func removeRemainingIngredient(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let row = indexPath.row
        var combined = flourIngredients + remainingIngredients
        let removedIngredient = combined.remove(at: row)
        let remainingIngredientIndex = remainingIngredients.firstIndex(of: removedIngredient)
        if let remainingIngredientIndex = remainingIngredientIndex {
            remainingIngredients.remove(at: remainingIngredientIndex)
        }
        ingredientTable.deleteRows(at: [indexPath], with: .none)
        ingredientTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let combinedIngredients = flourIngredients + remainingIngredients
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.cancelButton.tag = row
        cell.cancelButton.addTarget(self, action: #selector(removeRemainingIngredient(sender:)), for: .touchUpInside)
        if row <= flourIngredients.count - 1 {
            cell.cancelButton.isHidden = true
        } else {
            cell.cancelButton.isHidden = false
        }
        
        cell.textLabel?.text = combinedIngredients[row].formatted()
        
        return cell
    }
    
    func addRemainingIngredients(lbs: String?, oz: String?, name: String?) {
        let unwrappedPounds = unwrap(lbs)
        let unwrappedOunces = unwrap(oz)
        let ingredient = Ingredient(name: name!, pounds: unwrappedPounds, ounces: unwrappedOunces)
        
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
    
    // Unwraps the optional String where the desired value is a double.
    // This unwraps and provides a default value if null
    private func unwrap(_ value: String?) -> Double {
        return value == "" ? 0.0 : Double(value!)!
    }

}
