//
//  LogInViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let redColor = UIColor.red.cgColor
    let defaultColor = UIColor.lightGray.cgColor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        logInButton.layer.cornerRadius = 20
        
        invalidEmailLabel.isHidden = true
        invalidPasswordLabel.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func emailTextFieldDidChange() {
        emailTextField.layer.borderColor = defaultColor
        emailTextField.layer.borderWidth = 0.25
        invalidEmailLabel.isHidden = true
    }
    
    @objc func passwordTextFieldDidChange() {
        passwordTextField.layer.borderColor = defaultColor
        passwordTextField.layer.borderWidth = 0.25
        invalidPasswordLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        var emailValid = false
        if email.isEmpty == false {
            if email.isValid(String.ValidityType.email) {
                emailValid = true
            } else {
                emailFieldInvalid("Format email adrese nije validan!")
            }
        } else {
            emailFieldInvalid("Email polje je obavezno!")
        }
        
        if password.isEmpty == false {
            if emailValid {
                MyVariables.foodManager.logInUser(email: email, password: password)
            }
        } else {
            passwordFieldInvalid("Password polje je obavezno!")
        }
    }
    
    private func emailFieldInvalid(_ msg: String) {
        emailTextField.layer.borderColor = redColor
        emailTextField.layer.borderWidth = 1.0
        invalidEmailLabel.text = msg
        invalidEmailLabel.isHidden = false
    }
    
    private func passwordFieldInvalid(_ msg: String) {
        passwordTextField.layer.borderColor = redColor
        passwordTextField.layer.borderWidth = 1.0
        invalidPasswordLabel.text = msg
        invalidPasswordLabel.isHidden = false
    }
}

extension LogInViewController : FoodManagerDelegate {
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        let controller = UserProfileNavigationController.instantiate()
        tabBarController?.viewControllers?.append(BasketViewController.instantiate())
        tabBarController?.viewControllers?.append(controller)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func didFailWithError(error: String) {
        if error == "Password neispravan" {
            passwordFieldInvalid(error)
        } else if error == "Korisnik nije pronađen. Prvo kreirajte profil." {
            emailFieldInvalid(error)
        } else {
            passwordFieldInvalid(error)
            emailFieldInvalid(error)
        }
    }
    
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
}
