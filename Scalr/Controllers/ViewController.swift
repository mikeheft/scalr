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
    @IBOutlet weak var flourPicker: UIPickerView!
    
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    var addRemainingGradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let colors = [#colorLiteral(red: 0.6352941176, green: 0.5176470588, blue: 0.368627451, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.1607843137, blue: 0.04705882353, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        self.ingredientName.inputView = UIView()
        self.ingredientName.inputAccessoryView = UIView()
        setUpFlourPicker()
        setUpIngredientTable()
        hideKeyboardWhenTappedAround()
    }

    // Add ingredients
    @IBAction func addIngredientBtnPressed(_ sender: AnyObject) {
        let lbs = self.pounds.text
        let oz = self.ounces.text
        let name = self.ingredientName.text
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
        self.view.endEditing(true)
        self.view.sendSubviewToBack(flourPicker)
        ingredientTable.reloadData()
    }
    
    func addIngredient(lbs: String?, oz: String?, name: String?) {
        let ounces = (oz ?? "").isEmpty ? "0.0" : oz!
        let pounds = (lbs ?? "").isEmpty ? "0" : lbs!

        let ingredient = Ingredient(name: name!, pounds: Double(pounds)!, ounces: Double(ounces)!)
        flourIngredients.append(ingredient)
    }
    
    @IBAction func addRemainingPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddRemaining", sender: self)
    }
    
    @IBAction func flourNamePressed(_ sender: UITextField) {
        view.bringSubviewToFront(flourPicker)
    }
    
    @IBAction func hideFlourPicker(_ sender: UIButton) {
        view.sendSubviewToBack(flourPicker)
    }
    
    // Base Alert
    func alertController(_ title: String, _ localizedString: String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString(localizedString, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        return alertController
    }
    
    // Table Views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flourIngredients.count
    }
    
    @objc func removeIngredient(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        flourIngredients.remove(at: indexPath.row)
        ingredientTable.deleteRows(at: [indexPath], with: .none)
        ingredientTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientCount = flourIngredients.count
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        let row = indexPath.row
        cell.cancelButton.tag = row
        cell.cancelButton.addTarget(self, action: #selector(removeIngredient(sender:)), for: .touchUpInside)
        
        if row == 0 && ingredientCount == 0 {
            cell.cancelButton.isHidden = true
        } else {
            cell.cancelButton.isHidden = false
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
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.ingredientTable.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    private func setUpFlourPicker() {
        self.flourPicker.delegate = self
        self.flourPicker.dataSource = self
    }
    
    private func setUpIngredientTable() {
        self.ingredientTable.delegate = self
        self.ingredientTable.dataSource = self
        self.registerTableViewCells()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = IngredientStruct.FLOURS[row]
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textColor = UIColor.black
        label.sizeToFit()
        DispatchQueue.main.async {  // change color of the middle row
            if let label = pickerView.view(forRow: row, forComponent: component) as? UILabel {
                label.textColor = UIColor.brown
            }
        }
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ingredientName.text = IngredientStruct.FLOURS[row]
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return IngredientStruct.FLOURS.count
    }
    
    
}
