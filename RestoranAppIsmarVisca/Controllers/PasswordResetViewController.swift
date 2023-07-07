//
//  PasswordResetViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 3. 7. 2023..
//

import UIKit
import Toast

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    let defaultColor = UIColor.lightGray.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invalidEmailLabel.isHidden = true
        
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        
        sendButton.layer.cornerRadius = 15
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        
        MyVariables.foodManager.delegate = self
    }
    
    @objc func emailTextFieldDidChange() {
        emailTextField.layer.borderColor = defaultColor
        emailTextField.layer.borderWidth = 0.25
        invalidEmailLabel.isHidden = true
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text!
        
        if email.isEmpty == false {
            if email.isValid(String.ValidityType.email) {
                MyVariables.foodManager.resetUserPassword(email: email)
            } else {
                textFieldInvalid("Format email adrese nije validan!",textField: emailTextField, label: invalidEmailLabel)
            }
        } else {
            textFieldInvalid("Polje je prazno!",textField: emailTextField, label: invalidEmailLabel)
        }
    }
    
}

extension PasswordResetViewController : FoodManagerDelegate {
    
    func didUpdateUser(_ foodManager: FoodManager) {
        navigationController?.view.makeToast("Email poslan!", duration: 2.0, position: .bottom)
    }
    
    func didFailWithError(error: String) {
        textFieldInvalid(error, textField: emailTextField, label: invalidEmailLabel)
    }
    
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}
