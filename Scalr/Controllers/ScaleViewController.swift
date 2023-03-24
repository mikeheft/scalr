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
    var scaledIngredients: [IngredientStruct] = []
    var noPortions: String = ""
    var poundsPerPortion: String = ""
    var ouncesPerPortion: String = ""
    
    @IBOutlet weak var desiredNoOfPortions: UITextField!
    @IBOutlet weak var desiredPoundsPerPortion: UITextField!
    @IBOutlet weak var desiredOuncesPerPortion: UITextField!
    
    @IBOutlet weak var initialNoPortions: UITextField!
    @IBOutlet weak var initialPoundsPerPortion: UITextField!
    @IBOutlet weak var initialOuncesPerPortion: UITextField!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsTable.delegate = self
        self.ingredientsTable.dataSource = self
        hideKeyboardWhenTappedAround()
        self.registerTableViewCells()
        setInitialDefaults()
        
        Ingredient.calculatePercentages(flours: flourIngredients, remaining: remainingIngredients)
        ingredientsTable.reloadData()
    }
    
    @IBAction func scaleButtonPressed(_ sender: UIButton) {
        let noOfPortions = desiredNoOfPortions.text
        let poundsPerPortion = desiredPoundsPerPortion.text
        let ouncesPerPortion = desiredOuncesPerPortion.text
        desiredPortions(noOfPortions, poundsPerPortion, ouncesPerPortion)
    }

    @IBAction func startOverPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    @IBAction func desiredPrimaryACtionTriggered(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    private func desiredPortions(_ noPortions: String?, _ poundsPerPortion: String?, _ ouncesPerPortion: String?) {
        let noPortions = unwrap(noPortions)
        let poundsPerPortion = unwrap(poundsPerPortion)
        let ouncesPerPortion = unwrap(ouncesPerPortion)
         
        let dict: [String:Double] = ["noPortions": noPortions, "poundsPerPortion": poundsPerPortion, "ouncesPerPortion": ouncesPerPortion]
        
        scaledIngredients = Ingredient.scale(desiredPortionAmounts: dict, flours: flourIngredients, remaining: remainingIngredients)
        ingredientsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStart" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.flourIngredients = []
            destinationVC.remainingIngredients = []
        }
    }
    
    func setInitialDefaults() {
//        let combinedIngredients: [Ingredient] = flourIngredients + remainingIngredients
//
//        let result = combinedIngredients.reduce(into: [String:Double]()) { acc, ing in
//            let oz = acc["ounces", default: 0.0] + Double(ing.getOunces())
//            let lbs = acc["pounds", default: 0.0] + Double(ing.getPounds() / 16.0)
//            acc["pounds"] = lbs
//            acc["ounces"] = oz
//        }
        initialNoPortions.text = noPortions
        initialPoundsPerPortion.text = poundsPerPortion
        initialOuncesPerPortion.text = ouncesPerPortion
        self.desiredOuncesPerPortion.text = ouncesPerPortion
        self.desiredPoundsPerPortion.text = poundsPerPortion
        self.desiredNoOfPortions.text = noPortions
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flourIngredients.count + remainingIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var combinedIngredients: [IngredientStruct]
        if scaledIngredients.isEmpty {
            combinedIngredients = (flourIngredients + remainingIngredients).map {
                return IngredientStruct(name: $0.getName(), pounds: $0.getPounds(), ounces: $0.getOunces(), bakersPercentage: $0.getBakersPercentage(), scaled: false)
            }
        } else {
            combinedIngredients = scaledIngredients
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomScaledTableViewCell") as! CustomScaledTableViewCell
        
        let ingredient = combinedIngredients[row]
        let ingredientOunces = ingredient.getOunces()
        let formattedPounds = ingredient.getFormattedPounds()
    
        if ingredient.getPounds() >= 1 && ingredientOunces == 0.0 {
            cell.ouncesLabel.text = formattedPounds
        } else if ingredient.getPounds() > 0.0 {
            cell.poundsLabel.text = formattedPounds
        }
        
        if ingredientOunces > 0.0 {
            cell.ouncesLabel.text = ingredient.getFormattedOunces()
        }
        
        cell.nameLabel.text = ingredient.getName()
        cell.percentageLabel.text = ingredient.formattedPercentage()
        
        return cell
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomScaledTableViewCell",
                                  bundle: nil)
        self.ingredientsTable.register(textFieldCell,
                                forCellReuseIdentifier: "CustomScaledTableViewCell")
    }
    
    private func unwrap(_ value: String?) -> Double {
        var unwrappedValue: Double!
        if value == nil || value == "" {
            unwrappedValue = 0.0
        } else {
            unwrappedValue = Double(value!)!
        }
        
        return unwrappedValue
    }
}
