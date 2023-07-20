//
//  UIDatePickerExtension.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 19. 7. 2023..
//

import UIKit

extension UIDatePicker {

var textColor: UIColor? {
    set {
        setValue(newValue, forKeyPath: "textColor")
    }
    get {
        return value(forKeyPath: "textColor") as? UIColor
    }
  }
}
