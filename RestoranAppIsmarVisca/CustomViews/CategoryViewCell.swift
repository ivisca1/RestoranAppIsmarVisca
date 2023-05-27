//
//  CategoryViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 26. 5. 2023..
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryViewCell.self)
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    func setup(category : DishCategory) {
        categoryTitleLabel.text = category.name
        categoryImageView.image = UIImage(named: category.image)
    }
}
