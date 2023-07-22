//
//  MyVariables.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 1. 6. 2023..
//

import UIKit


struct MyVariables {
    static var foodManager = FoodManager()
    static var promotions = [Promotion(firstLabel: "Pratite nas na Instagramu!", secondLabel: "@yummiesarajevo", image: "instagram"), Promotion(firstLabel: "Pratite nas na Facebook-u", secondLabel: "Yummie Sarajevo", image: "facebook"), Promotion(firstLabel: "Kontaktirajte nas!", secondLabel: "+387 61 123 456", image: "phone")]
    static let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
        return activityIndicator
    }()
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
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr=="ć") && !(chr=="Ć") && !(chr=="č") && !(chr=="Č") && !(chr=="ž") && !(chr=="Ž") && !(chr=="š") && !(chr=="Š") && !(chr=="đ") && !(chr=="Đ")) {
         return false
      }
   }
   return true
}
