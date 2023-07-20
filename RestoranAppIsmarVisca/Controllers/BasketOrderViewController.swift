//
//  BasketOrderViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 14. 6. 2023..
//

import UIKit

class BasketOrderViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var basketTableView: UITableView!
    
    var address : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MyVariables.foodManager.user != nil {
            self.updateBasketBadge()
        }

        setUpEverything()
        
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        if MyVariables.foodManager.user != nil && MyVariables.foodManager.ordered {
            MyVariables.foodManager.isOrderDelivered()
        }
    }
}

extension BasketOrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyVariables.foodManager.basketDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFoodViewCell.identifier) as! SearchFoodViewCell
        cell.setup(food: MyVariables.foodManager.basketDishes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
    }
}

extension BasketOrderViewController : FoodManagerDelegate {
    
    func didDeliverOrder(_ foodManager: FoodManager) {
        let controller = BasketViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?[2]
        tabBarController?.viewControllers?.remove(at: 3)
    }
    
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {}
    func didMakeReservation(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

extension BasketOrderViewController {
    
    private func setUpEverything() {
        
        detailsView.clipsToBounds = true
        detailsView.layer.cornerRadius = 70
        detailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addressLabel.text = address
        nameSurnameLabel.text = "\(MyVariables.foodManager.user!.name) \(MyVariables.foodManager.user!.surname)"
        phoneNumberLabel.text = MyVariables.foodManager.user?.phoneNumber
        var totalPrice = 0
        for dish in MyVariables.foodManager.basketDishes {
            totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
        }
        totalPriceLabel.text = "\(totalPrice) KM"
    }
    
    private func registerCells() {
        basketTableView.register(UINib(nibName: SearchFoodViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchFoodViewCell.identifier)
    }
}
