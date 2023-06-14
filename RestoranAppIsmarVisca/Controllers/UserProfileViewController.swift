//
//  UserProfileViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 9. 6. 2023..
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameSurnameLabel.text = "\(user.name) \(user.surname)"
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        addressLabel.text = user.address
        
        MyVariables.foodManager.fetchBasket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }

    @IBAction func logOutClicked(_ sender: UIButton) {
        MyVariables.foodManager.logOutUser()
    }
    @IBAction func changeDetailsClicked(_ sender: UIButton) {
    }
}

extension UserProfileViewController : FoodManagerDelegate {
    func didLogOutUser(_ foodManager: FoodManager) {
        tabBarController?.viewControllers?.append(NoBasketViewController.instantiate())
        tabBarController?.viewControllers?.append(ProfileNavigationViewController.instantiate())
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        DispatchQueue.main.async {
            let tabBar = self.tabBarController!.tabBar
            let basketItem = tabBar.items![2]
            basketItem.badgeColor = UIColor.red
            basketItem.badgeValue = "\(dishes.count)"
        }
    }
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {
        
    }
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {
        
    }
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}