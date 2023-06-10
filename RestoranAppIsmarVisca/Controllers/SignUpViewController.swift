//
//  SignUpViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameSurnameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameSurnameTextField.layer.cornerRadius = 15
        nameSurnameTextField.clipsToBounds = true
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
        if let name = nameSurnameTextField.text?.components(separatedBy: " ").first {
            if let surname = nameSurnameTextField.text?.components(separatedBy: " ")[1] {
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
    func didLogOutUser(_ foodManager: FoodManager) {
        
    }
    
    func didSignInUser(_ foodManager: FoodManager, user: User) {
        let controller = UserProfileViewController.instantiate()
        controller.user = user
        tabBarController?.viewControllers?.append(controller)
        tabBarController?.viewControllers?.remove(at: 3)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    
    func didFailWithError(error: Error) {}
}
