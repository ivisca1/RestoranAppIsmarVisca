//
//  MyVariables.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 1. 6. 2023..
//

import UIKit


struct MyVariables {
    static var foodManager = FoodManager()
}

func textFieldInvalid(_ msg: String, textField: UITextField!, label: UILabel!) {
    let redColor = UIColor.red.cgColor
    textField.layer.borderColor = redColor
    textField.layer.borderWidth = 1.0
    label.text = msg
    label.isHidden = false
}

func containsOnlyLetters(str: String) -> Bool {
   for chr in str {
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
         return false
      }
   }
   return true
}

func containsOnlyNumbers(str: String) -> Bool {
   for chr in str {
      if (!(chr >= "0" && chr <= "9")) {
         return false
      }
   }
   return true
}
