//
//  SearchViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var shouldSearchFood = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 36)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.831, green: 0.765, blue: 0.51, alpha: 1.0)]

        searchTextField.delegate = self
        registerCells()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        if MyVariables.foodManager.user != nil {
            self.updateBasketBadge()
        }
        
        if MyVariables.foodManager.user != nil && MyVariables.foodManager.ordered {
            MyVariables.foodManager.isOrderDelivered()
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: SearchFoodViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchFoodViewCell.identifier)
    }
}

extension SearchViewController : UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let food = searchTextField.text!
        MyVariables.foodManager.fetchFoodSearch(document: "food", searchText: food)
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldSearchFood = true
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let food = searchTextField.text!
        if food.isEmpty == false && shouldSearchFood {
            MyVariables.foodManager.fetchFoodSearch(document: "food", searchText: food)
            shouldSearchFood = false
        }
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyVariables.foodManager.searchDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFoodViewCell.identifier) as! SearchFoodViewCell
        cell.setup(food: MyVariables.foodManager.searchDishes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instantiate()
        controller.dish = MyVariables.foodManager.searchDishes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchViewController : FoodManagerDelegate {
    
    func didDeliverOrder(_ foodManager: FoodManager) {
        let controller = BasketViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
        self.updateBasketBadge()
    }
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {
        tableView.reloadData()
    }
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

