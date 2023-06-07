//
//  UIViewControllerExtension.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 5. 6. 2023..
//

import UIKit

extension UIViewController {
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
    
}
