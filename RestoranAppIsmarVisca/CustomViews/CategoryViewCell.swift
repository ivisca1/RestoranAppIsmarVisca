//
//  CategoryViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 26. 5. 2023..
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryViewCell.self)
    
    @IBOutlet weak var view: CategoryCardView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    func setup(category : DishCategory, redBackground : Bool) {
        categoryTitleLabel.text = category.name
        categoryImageView.image = UIImage(named: category.image)
        view.backgroundColor = UIColor(red: 0.427, green: 0.42, blue: 0.714, alpha: 1.0)
        if redBackground {
            view.backgroundColor = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
        }
    }
}
