//
//  ViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/3/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    @IBOutlet weak var addRemaining: UIButton!
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var ounces: UITextField!
    @IBOutlet weak var pounds: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    var addRemainingGradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let colors = [#colorLiteral(red: 0.6352941176, green: 0.5176470588, blue: 0.368627451, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.04705882353, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addRemainingGradient?.frame = addRemaining.bounds
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
        flourIngredients.append(ingredient)
    }
    
    @IBAction func addRemainingPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddRemaining", sender: self)
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
        let ingredientCount: Int = flourIngredients.count
        return ingredientCount <= 1 ? 1 : ingredientCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientCount = flourIngredients.count
        let cell = ingredientTable.dequeueReusableCell(withIdentifier: "amounts", for: indexPath)
        let row = indexPath.row
        
        if row == 0  && ingredientCount == 0 {
            cell.textLabel?.text = "Add Flour(s)"
        } else {
            cell.textLabel?.text = flourIngredients[row].formatted()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAddRemaining" {
            let destinationVC = segue.destination as! RemainingIngredientsViewController
            destinationVC.flourIngredients = flourIngredients
        }
    }
    
}
