//
//  BasketViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var basketTabBar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEverything()
        
        if MyVariables.foodManager.user != nil {
            self.updateBasketBadge()
        }
        
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        refreshView()
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        if MyVariables.foodManager.basketDishes.isEmpty {
            self.showAlert(title: "Neuspješna narudžba!", message: "Vaša korpa je prazna")
        } else {
            MyVariables.foodManager.makeOrder(newAddress: addressLabel.text!)
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Promjena adrese", message: "Promjena važi samo za ovu narudžbu!", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.addressLabel.text
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text?.isEmpty == false {
                self.addressLabel.text = textField?.text
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension BasketViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyVariables.foodManager.basketDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketFoodCollectionViewCell.identifier) as! BasketFoodCollectionViewCell
        cell.setup(foodDish: MyVariables.foodManager.basketDishes[indexPath.row], indexRow: indexPath.row)
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

extension BasketViewController : FoodManagerDelegate {
    
    func didMakeOrder(_ foodManager: FoodManager) {
        let controller = BasketOrderViewController.instantiate()
        controller.address = addressLabel.text!
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?[2]
        tabBarController?.viewControllers?.remove(at: 3)
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        refreshView()
        
        self.updateBasketBadge()
    }
    
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
}

extension BasketViewController {
    
    private func setUpEverything() {
        
        addressLabel.text = MyVariables.foodManager.user?.address
        orderButton.layer.cornerRadius = 20
        changeButton.layer.cornerRadius = 10
        basketTableView.layer.cornerRadius = 30
        
        detailsView.clipsToBounds = true
        detailsView.layer.cornerRadius = 70
        detailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func refreshView() {
        
        var totalPrice = 0
        
        for dish in MyVariables.foodManager.basketDishes {
            totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
        }
        
        priceLabel.text = "\(totalPrice) KM"
        
        basketTableView.reloadData()
    }
    
    private func registerCells() {
        basketTableView.register(UINib(nibName: BasketFoodCollectionViewCell.identifier, bundle: nil), forCellReuseIdentifier: BasketFoodCollectionViewCell.identifier)
    }
}
