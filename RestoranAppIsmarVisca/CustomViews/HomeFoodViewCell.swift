//
//  HomeFoodViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class HomeFoodViewCell: UICollectionViewCell {
    
    static let identifier = "HomeFoodViewCell"

    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    func setup(foodDish: FoodDish) {
        foodPriceLabel.text = foodDish.price
        foodNameLabel.text = foodDish.name
        foodImageView.image = UIImage(named: foodDish.image)
    }
}
