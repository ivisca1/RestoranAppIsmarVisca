//
//  DishDetailViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 27. 5. 2023..
//

import UIKit

class DishDetailViewController: UIViewController {

    @IBOutlet weak var foodDetailView: UIView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var dishDescriptionLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishTitleLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!

    var dish : FoodDish!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dishImageView.image = UIImage(named: dish.image)
        dishTitleLabel.text = dish.name
        dishPriceLabel.text = dish.price
        dishDescriptionLabel.text = dish.description
        orderButton.layer.cornerRadius = 20
        foodDetailView.layer.cornerRadius = 70
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func placeOrderButtonClicked(_ sender: UIButton) {
        if MyVariables.foodManager.user != nil {
            MyVariables.foodManager.addToBasket(dishName: dishTitleLabel.text ?? "Hamburger")
            let alert = UIAlertController(title: "Dodano u korpu!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Niste prijavljeni!", message: "Molimo Vas prijavite se!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
