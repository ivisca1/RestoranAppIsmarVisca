//
//  DishDetailViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 27. 5. 2023..
//

import UIKit

class DishDetailViewController: UIViewController {

    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var dishDescriptionLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishTitleLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func placeOrderButtonClicked(_ sender: UIButton) {
    }
}
