//
//  SignUpViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
        surnameTextField.layer.cornerRadius = 15
        surnameTextField.clipsToBounds = true
        phoneNumberTextField.layer.cornerRadius = 15
        phoneNumberTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        addressTextField.layer.cornerRadius = 15
        addressTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordAgainTextField.layer.cornerRadius = 15
        passwordAgainTextField.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if let name = nameTextField.text {
            if let surname = surnameTextField.text {
                if let phoneNumber = phoneNumberTextField.text {
                    if let email = emailTextField.text {
                        if let address = addressTextField.text {
                            if let password = passwordTextField.text {
                                if let passwordAgain = passwordAgainTextField.text {
                                    if password == passwordAgain {
                                        let user = User(name: name, surname: surname, phoneNumber: phoneNumber, email: email, address: address)
                                        MyVariables.foodManager.createUser(userToCreate: user, password: password)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SignUpViewController : FoodManagerDelegate {
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        let controller = UserProfileNavigationController.instantiate()
        tabBarController?.viewControllers?.append(controller)
        tabBarController?.viewControllers?.remove(at: 3)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
    }
    
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
}
