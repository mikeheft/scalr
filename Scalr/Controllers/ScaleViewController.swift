//
//  ScaleViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/4/23.
//

import UIKit

class ScaleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    
    @IBOutlet weak var initialOuncesTextField: UITextField!
    @IBOutlet weak var initialPoundsTextField: UITextField!
    @IBOutlet weak var initialNoOfPortionsTextField: UITextField!
    
    @IBOutlet weak var desiredNoOfPortions: UITextField!
    @IBOutlet weak var desiredPoundsTextField: UITextField!
    @IBOutlet weak var desiredOuncesTextField: UITextField!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsTable.delegate = self
        self.ingredientsTable.dataSource = self
        hideKeyboardWhenTappedAround()
        self.registerTableViewCells()
        
        setInitialDefaults()
        
        Ingredient.scale(flours: flourIngredients, remaining: remainingIngredients)
        ingredientsTable.reloadData()
    }
    
    @IBAction func scaleButtonPressed(_ sender: UIButton) {
//        Ingredient.scale(flours: flourIngredients, remaining: remainingIngredients)
//        ingredientsTable.reloadData()
    }
    
    @IBAction func startOverPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    @IBAction func desiredPrimaryACtionTriggered(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStart" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.flourIngredients = []
            destinationVC.remainingIngredients = []
        }
    }
    
    func setInitialDefaults() {
        let combinedIngredients: [Ingredient] = flourIngredients + remainingIngredients
        
        let result = combinedIngredients.reduce(into: [String:Float]()) { acc, ing in
            let lbs = acc["pounds", default: 0.0] + Float(ing.pounds)
            let oz = acc["ounces", default: 0.0] + ing.ounces
            acc["pounds"] = lbs
            acc["ounces"] = oz
        }
        self.initialPoundsTextField.text = String(format: "%.0f%",result["pounds"] ?? 0.0)
        self.initialOuncesTextField.text = String(result["ounces"] ?? 0.0)
        self.initialNoOfPortionsTextField.text = "1"
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flourIngredients.count + remainingIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let combinedIngredients = flourIngredients + remainingIngredients
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomScaledTableViewCell") as! CustomScaledTableViewCell
        
        let ingredient = combinedIngredients[row]
        let pounds = ingredient.formattedPounds()
    
        if ingredient.pounds >= 1 && ingredient.ounces == 0.0 {
            cell.ouncesLabel.text = pounds
        } else if ingredient.pounds >= 1 {
            cell.poundsLabel.text = pounds
        }
        if ingredient.ounces > 0.0 {
            cell.ouncesLabel.text = ingredient.formattedOunces()
        }
        
        cell.nameLabel.text = ingredient.name
        cell.percentageLabel.text = ingredient.formattedPercentage()
        
        return cell
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomScaledTableViewCell",
                                  bundle: nil)
        self.ingredientsTable.register(textFieldCell,
                                forCellReuseIdentifier: "CustomScaledTableViewCell")
    }
}
