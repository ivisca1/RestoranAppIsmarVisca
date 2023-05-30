//
//  SearchFoodViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 29. 5. 2023..
//

import UIKit

class SearchFoodViewCell: UITableViewCell {

    static let identifier = String(describing: SearchFoodViewCell.self)
    
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    func setup(food : FoodDish) {
        foodPriceLabel.text = food.price
        foodNameLabel.text = food.name
        foodImageView.image = UIImage(named: food.image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
}
