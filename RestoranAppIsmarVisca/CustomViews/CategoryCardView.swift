//
//  CategoryCardView.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 26. 5. 2023..
//

import UIKit

class CategoryCardView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = 20
        //layer.backgroundColor = CGColor(red: 0.427, green: 0.42, blue: 0.714, alpha: 1.0)
    }
}
