//
//  ChangeUserDetailsViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 15. 6. 2023..
//

import UIKit

class ChangeUserDetailsViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white

        let user = MyVariables.foodManager.user

        addressTextField.text = user?.address
        phoneNumberTextField.text = user?.phoneNumber
        surnameTextField.text = user?.surname
        nameTextField.text = user?.name
    }
    

    @IBAction func changeButtonPressed(_ sender: UIButton) {
    }
}
