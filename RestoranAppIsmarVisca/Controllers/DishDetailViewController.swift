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
    
    var image : String?
    var name : String?
    var price : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dishImageView.image = UIImage(named: image ?? "burger")
        dishTitleLabel.text = name
        dishPriceLabel.text = price
        foodDetailView.layer.cornerRadius = 70
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func placeOrderButtonClicked(_ sender: UIButton) {
    }
}
