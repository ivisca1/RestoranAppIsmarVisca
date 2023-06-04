//
//  BasketViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var basketTabBar: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        orderButton.layer.cornerRadius = 10
        changeButton.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 15
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        basketTableView.reloadData()
    }
    
    private func registerCells() {
        basketTableView.register(UINib(nibName: BasketFoodCollectionViewCell.identifier, bundle: nil), forCellReuseIdentifier: BasketFoodCollectionViewCell.identifier)
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
    }
    @IBAction func changeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
    }
}

extension BasketViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyVariables.foodManager.basketDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketFoodCollectionViewCell.identifier) as! BasketFoodCollectionViewCell
        cell.setup(foodDish: MyVariables.foodManager.basketDishes[indexPath.row])
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
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {
        
    }
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {
        
    }
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        basketTableView.reloadData()
        let tabBar = self.tabBarController!.tabBar
        let basketItem = tabBar.items![2]
        basketItem.badgeColor = UIColor.red
        basketItem.badgeValue = "\(MyVariables.foodManager.basketDishes.count)"
    }
}
