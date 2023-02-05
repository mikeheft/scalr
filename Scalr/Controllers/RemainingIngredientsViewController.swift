//
//  RemainingIngredientsViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/4/23.
//

import UIKit

class RemainingIngredientsViewController: UIViewController {
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.performSegue(withIdentifier: "goToAddRemaining", sender: self)
        // Do any additional setup after loading the view.
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

}
