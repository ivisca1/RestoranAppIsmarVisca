//
//  SignUpViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var invalidPasswordAgainLabel: UILabel!
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var invalidAddressLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var invalidPhoneNumberLabel: UILabel!
    @IBOutlet weak var invalidSurnameLabel: UILabel!
    @IBOutlet weak var invalidNameLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    let defaultColor = UIColor.lightGray.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEverything()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text!
        let surname = surnameTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let email = emailTextField.text!
        let address = addressTextField.text!
        let password = passwordTextField.text!
        let passwordAgain = passwordAgainTextField.text!
        
        var nameValid = false
        if name.isEmpty == false {
            if containsOnlyLetters(str: name) {
                print("TU SAM")
            } else {
                textFieldInvalid("Ime treba da sadrži samo slova!", textField: nameTextField, label: invalidNameLabel)
            }
        } else {
            textFieldInvalid("Ime polje je obavezno!", textField: nameTextField, label: invalidNameLabel)
        }
        
        //let user = User(name: name, surname: surname, phoneNumber: phoneNumber, email: email, address: address)
        //MyVariables.foodManager.createUser(userToCreate: user, password: password)

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

extension SignUpViewController {
    
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
    
    @objc func passwordAgainTextFieldDidChange() {
        passwordAgainTextField.layer.borderColor = defaultColor
        passwordAgainTextField.layer.borderWidth = 0.25
        invalidPasswordAgainLabel.isHidden = true
    }
    
    @objc func nameTextFieldDidChange() {
        nameTextField.layer.borderColor = defaultColor
        nameTextField.layer.borderWidth = 0.25
        invalidNameLabel.isHidden = true
    }
    
    @objc func surnameTextFieldDidChange() {
        surnameTextField.layer.borderColor = defaultColor
        surnameTextField.layer.borderWidth = 0.25
        invalidSurnameLabel.isHidden = true
    }
    
    @objc func addressTextFieldDidChange() {
        addressTextField.layer.borderColor = defaultColor
        addressTextField.layer.borderWidth = 0.25
        invalidAddressLabel.isHidden = true
    }
    
    @objc func phoneNumberTextFieldDidChange() {
        phoneNumberTextField.layer.borderColor = defaultColor
        phoneNumberTextField.layer.borderWidth = 0.25
        invalidPhoneNumberLabel.isHidden = true
    }
    
    private func setUpEverything() {
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
        
        invalidEmailLabel.isHidden = true
        invalidPasswordLabel.isHidden = true
        invalidPasswordAgainLabel.isHidden = true
        invalidNameLabel.isHidden = true
        invalidSurnameLabel.isHidden = true
        invalidAddressLabel.isHidden = true
        invalidPhoneNumberLabel.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        passwordAgainTextField.addTarget(self, action: #selector(passwordAgainTextFieldDidChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(surnameTextFieldDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
    }
}
