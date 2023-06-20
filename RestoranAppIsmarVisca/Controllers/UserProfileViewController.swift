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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyVariables.foodManager.fetchBasket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        let user = MyVariables.foodManager.user!
        
        nameSurnameLabel.text = "\(user.name) \(user.surname)"
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        addressLabel.text = user.address
        
        if MyVariables.foodManager.user != nil {
            let tabBar = self.tabBarController!.tabBar
            let basketItem = tabBar.items![2]
            basketItem.badgeColor = UIColor.red
            basketItem.badgeValue = "\(MyVariables.foodManager.basketDishes.count)"
        }
        
        if MyVariables.foodManager.user != nil && MyVariables.foodManager.ordered {
            MyVariables.foodManager.isOrderDelivered()
        }
    }

    @IBAction func logOutClicked(_ sender: UIButton) {
        MyVariables.foodManager.logOutUser()
    }
    @IBAction func changeDetailsClicked(_ sender: UIButton) {
        let controller = ChangeUserDetailsViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension UserProfileViewController : FoodManagerDelegate {
    
    func didDeliverOrder(_ foodManager: FoodManager) {
        let controller = BasketViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
    }
    
    func didLogOutUser(_ foodManager: FoodManager) {
        tabBarController?.viewControllers?.append(NoBasketViewController.instantiate())
        tabBarController?.viewControllers?.append(ProfileNavigationViewController.instantiate())
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        DispatchQueue.main.async {
            let tabBar = self.tabBarController!.tabBar
            let basketItem = tabBar.items![2]
            basketItem.badgeColor = UIColor.red
            basketItem.badgeValue = "\(dishes.count)"
        }
    }
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
}
