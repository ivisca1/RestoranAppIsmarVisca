//
//  BasketFoodCollectionViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 3. 6. 2023..
//

import UIKit

class BasketFoodCollectionViewCell: UITableViewCell {
    
    static let identifier = "BasketFoodCollectionViewCell"
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        MyVariables.foodManager.removeFromBasket(dishName: foodNameLabel.text!)
    }
    
    func setup(foodDish: FoodDish) {
        foodPriceLabel.text = foodDish.price
        foodNameLabel.text = foodDish.name
        foodImageView.image = UIImage(named: foodDish.image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
}
