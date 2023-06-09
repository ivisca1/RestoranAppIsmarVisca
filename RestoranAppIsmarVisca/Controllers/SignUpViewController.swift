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
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
    }
}
