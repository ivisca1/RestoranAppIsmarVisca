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
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: SearchFoodViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchFoodViewCell.identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchDishDetail" {
            let destinationVC = segue.destination as! DishDetailViewController
            destinationVC.image = MyVariables.foodManager.searchDishes[index].image
            destinationVC.name = MyVariables.foodManager.searchDishes[index].name
            destinationVC.price = MyVariables.foodManager.searchDishes[index].price
            destinationVC.desc = MyVariables.foodManager.searchDishes[index].description
        }
    }
}

extension SearchViewController : UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let food = searchTextField.text {
            MyVariables.foodManager.fetchFoodSearch(document: "food", searchText: food)
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
        index = indexPath.row
        performSegue(withIdentifier: "searchDishDetail", sender: tableView)
    }
}

extension SearchViewController : FoodManagerDelegate {
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {
        tableView.reloadData()
    }
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    
    func didFailWithError(error: Error) {}
}

