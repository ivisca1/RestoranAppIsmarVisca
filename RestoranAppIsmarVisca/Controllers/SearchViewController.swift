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
    
    var populars : [FoodDish] = [
        .init(id: "1", image: "burger", name: "Hamburger", price: "12 KM"),
        .init(id: "1", image: "margarita", name: "Margarita", price: "8 KM"),
        .init(id: "1", image: "sladoled", name: "Sladoled", price: "5 KM"),
        .init(id: "1", image: "pomfrit", name: "Pomfrit", price: "2 KM"),
        .init(id: "1", image: "burger", name: "Pomfrit", price: "2 KM"),
        .init(id: "1", image: "margarita", name: "Pomfrit", price: "2 KM"),
        .init(id: "1", image: "sladoled", name: "Pomfrit", price: "2 KM"),
        .init(id: "1", image: "pomfrit", name: "Pomfrit", price: "2 KM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: SearchFoodViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchFoodViewCell.identifier)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFoodViewCell.identifier) as! SearchFoodViewCell
        cell.setup(food: populars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
