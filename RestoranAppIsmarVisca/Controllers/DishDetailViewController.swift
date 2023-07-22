//
//  DishDetailViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 27. 5. 2023..
//

import UIKit
import Toast

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
        orderButton.layer.cornerRadius = 15
        foodDetailView.layer.cornerRadius = 70
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.view.hideAllToasts()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func placeOrderButtonClicked(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        if MyVariables.foodManager.user != nil {
            if MyVariables.foodManager.ordered {
                navigationController?.view.makeToast("Molimo vas sačekajte da se završi narudžba!", duration: 2.0, position: .bottom, title: "Imate već naručenu narudžbu!", image: nil)
            } else {
                navigationController?.view.makeToast("Dodano u korpu!", duration: 2.0, position: .bottom, title: dishTitleLabel.text, image: dishImageView.image)
                MyVariables.foodManager.addToBasket(dishName: dishTitleLabel.text ?? "Hamburger")
            }
        } else {
            navigationController?.view.makeToast("Molimo Vas prijavite se!", duration: 2.0, position: .bottom, title: "Niste prijavljeni!", image: nil)
        }
    }
}
