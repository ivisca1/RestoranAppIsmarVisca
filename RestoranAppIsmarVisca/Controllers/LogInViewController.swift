//
//  LogInViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    let defaultColor = UIColor.lightGray.cgColor
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEverything()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        let controller = PasswordResetViewController.instantiate()
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        tryToLogIn()
    }
}

extension LogInViewController : FoodManagerDelegate {
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        stopSpinner()
        let controller = UserProfileNavigationController.instantiate()
        tabBarController?.viewControllers?.append(BasketViewController.instantiate())
        tabBarController?.viewControllers?.append(ReservationsViewController.instantiate())
        tabBarController?.viewControllers?.append(controller)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func didFailWithError(error: String) {
        stopSpinner()
        if error == "Šifra neispravna!" {
            textFieldInvalid(error, textField: passwordTextField, label: invalidPasswordLabel)
        } else if error == "Korisnik nije pronađen. Prvo kreirajte profil!" {
            textFieldInvalid(error, textField: emailTextField, label: invalidEmailLabel)
        } else {
            textFieldInvalid(error, textField: passwordTextField, label: invalidPasswordLabel)
            textFieldInvalid(error, textField: emailTextField, label: invalidEmailLabel)
        }
    }
    
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {}
    func didMakeReservation(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

extension LogInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
       } else {
           textField.resignFirstResponder()
       }
       
       if textField.tag == 1 {
           tryToLogIn()
           textField.endEditing(true)
           return true
       }
       
       return false
   }
}

extension LogInViewController {
    
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
    
    private func setUpEverything() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        navigationController?.navigationBar.tintColor = UIColor.white
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        logInButton.layer.cornerRadius = 15
        
        invalidEmailLabel.isHidden = true
        invalidPasswordLabel.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
    private func tryToLogIn() {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        var emailValid = false
        if email.isEmpty == false {
            if email.isValid(String.ValidityType.email) {
                emailValid = true
            } else {
                textFieldInvalid("Format email adrese nije validan!",textField: emailTextField, label: invalidEmailLabel)
            }
        } else {
            textFieldInvalid("Email polje je obavezno!",textField: emailTextField, label: invalidEmailLabel)
        }
        
        if password.isEmpty == false {
            if emailValid {
                showSpinner()
                MyVariables.foodManager.logInUser(email: email, password: password)
            }
        } else {
            textFieldInvalid("Šifra polje je obavezno!", textField: passwordTextField, label: invalidPasswordLabel)
        }
    }
    
    private func showSpinner() {
        
        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
            
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
            
        self.view.layoutSubviews()
    }
    
    private func stopSpinner() {
        
        activityIndicator.stopAnimating()
        
        activityIndicator.removeFromSuperview()
    }
}
