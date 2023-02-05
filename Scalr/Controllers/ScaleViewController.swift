//
//  ScaleViewController.swift
//  Scalr
//
//  Created by Michael Heft on 2/4/23.
//

import UIKit

class ScaleViewController: UIViewController {
    var flourIngredients: [Ingredient] = []
    var remainingIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func startOverPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToStart" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.flourIngredients = flourIngredients
            destinationVC.remainingIngredients = remainingIngredients
        }
    }

}
