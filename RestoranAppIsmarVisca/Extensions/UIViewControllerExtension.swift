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
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateBasketBadge() {
        let tabBar = self.tabBarController!.tabBar
        let basketItem = tabBar.items![2]
        basketItem.badgeColor = UIColor.red
        basketItem.badgeValue = "\(MyVariables.foodManager.basketDishes.count)"
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
