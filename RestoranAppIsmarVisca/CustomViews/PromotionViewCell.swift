//
//  PromotionViewCell.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 5. 7. 2023..
//

import UIKit

class PromotionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: PromotionViewCell.self)

    @IBOutlet weak var view: CategoryCardView!
    @IBOutlet weak var promotionImage: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    func setup(promotion: Promotion) {
        promotionImage.image = UIImage(named: promotion.image)
        firstLabel.text = promotion.firstLabel
        secondLabel.text = promotion.secondLabel
    }
}
