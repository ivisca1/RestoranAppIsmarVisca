//
//  ProfileViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        signUpButton.layer.cornerRadius = 20
        logInButton.layer.cornerRadius = 20
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        let controller = SignUpViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func logInButtonClicked(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        let controller = LogInViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
}
