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
    

    @IBOutlet weak var initialPoundsPerPortion: UITextField!
    @IBOutlet weak var initialOuncesPerPortion: UITextField!
    @IBOutlet weak var initialNoOfPortionsTextField: UITextField!
    
    @IBOutlet weak var desiredNoOfPortions: UITextField!
    @IBOutlet weak var desiredPoundsPerPortion: UITextField!
    @IBOutlet weak var desiredOuncesPerPortion: UITextField!

    
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
    
    @IBAction func desiredNoPortionsChanged(_ sender: UITextField) {
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
        let noPortions = Double(noPortions ?? "0.0")!
        let poundsPerPortion = Double(poundsPerPortion ?? "0.0")!
        let ouncesPerPortion = Double(ouncesPerPortion ?? "0.0")!
        let dict: [String:Double] = ["noPortions": noPortions, "poundsPerPortion": poundsPerPortion, "ouncesPerPortion":ouncesPerPortion]
        
        scaledIngredients = IngredientStruct.scale(desiredPortionAmounts: dict, flours: flourIngredients, remaining: remainingIngredients)
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
        let combinedIngredients: [Ingredient] = flourIngredients + remainingIngredients
        
        let result = combinedIngredients.reduce(into: [String:Double]()) { acc, ing in
            let lbs = acc["weightPerPortion", default: 0.0] + Double(ing.getPounds())
            let oz = acc["ounces", default: 0.0] + Double(ing.getOunces())
            acc["pounds"] = lbs
            acc["ounces"] = oz
        }
        self.initialPoundsPerPortion.text = String(format: "%.0f%",result["weightPerPortion"] ?? 0.0)
        self.initialNoOfPortionsTextField.text = "1"
        self.desiredPoundsPerPortion.text = String(format: "%.0f%",result["weightPerPortion"] ?? 0.0)
        self.desiredNoOfPortions.text = "1"
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
                return IngredientStruct(name: $0.getName(), pounds: $0.getPounds(), ounces: $0.getOunces(), bakersPercentage: $0.getBakersPercentage())
            }
        } else {
            combinedIngredients = scaledIngredients
        }
//        let combinedIngredients = flourIngredients + remainingIngredients
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomScaledTableViewCell") as! CustomScaledTableViewCell
        
        let ingredient = combinedIngredients[row]
        let formattedPounds = ingredient.formattedPounds()
    
        if ingredient.pounds >= 1 && ingredient.ounces == 0.0 {
            cell.ouncesLabel.text = formattedPounds
        } else if ingredient.pounds > 0.0 {
            cell.poundsLabel.text = formattedPounds
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
