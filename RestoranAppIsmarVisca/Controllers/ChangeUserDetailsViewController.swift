//
//  ChangeUserDetailsViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 15. 6. 2023..
//

import UIKit

class ChangeUserDetailsViewController: UIViewController {

    @IBOutlet weak var invalidAddressLabel: UILabel!
    @IBOutlet weak var invalidPhoneNumberLabel: UILabel!
    @IBOutlet weak var invalidSurnameLabel: UILabel!
    @IBOutlet weak var invalidNameLabel: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    

    @IBAction func changeButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text!
        let surname = surnameTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let address = phoneNumberTextField.text!
        
        var nameValid = false
        var surnameValid = false
        var phoneNumberValid = false
        var addressValid = false
        
        if name.isEmpty == false {
            nameValid = true
        } else {
            //name empty
        }
        
        if surname.isEmpty == false {
            surnameValid = true
        } else {
            //surname empty
        }
        
        if phoneNumber.isEmpty == false {
            phoneNumberValid = true
        } else {
            //phone empty
        }
        
        if address.isEmpty == false {
            addressValid = true
        } else {
            //address empty
        }
        
        if nameValid && surnameValid && phoneNumberValid && addressValid {
            MyVariables.foodManager.updateUser(name: name, surname: surname, phoneNumber: phoneNumber, address: address)
        }
    }
}

extension ChangeUserDetailsViewController : FoodManagerDelegate {
    func didUpdateUser(_ foodManager: FoodManager) {
        let alert = UIAlertController(title: "Uspješno ažurirani podaci", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
}
