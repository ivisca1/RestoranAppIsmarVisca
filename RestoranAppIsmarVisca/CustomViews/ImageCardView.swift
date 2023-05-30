//
//  CategoryCardView.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 26. 5. 2023..
//

import UIKit

class ImageCardView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = 20
    }
}
