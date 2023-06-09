//
//  LogInViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 8. 6. 2023..
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        logInButton.layer.cornerRadius = 20
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
    }
    

}
