//
//  BasketViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit
import Toast

class BasketViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var basketTabBar: UITabBarItem!
    
    var index = IndexPath()
    
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
            view.makeToast("Vaša korpa je prazna!", duration: 2.0, position: .bottom, title: "Neuspješna narudžba!", image: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            index = indexPath
            basketTableView.beginUpdates()
            MyVariables.foodManager.removeFromBasket(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Izbaci iz korpe"
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
        basketTableView.deleteRows(at: [index], with: .fade)
        basketTableView.endUpdates()
        
        refreshView()
        
        view.makeToast("Izbačeno iz korpe!", duration: 1.0, position: .bottom)
        
        self.updateBasketBadge()
    }
    
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {}
    func didMakeReservation(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

extension BasketViewController {
    
    private func setUpEverything() {
        
        addressLabel.text = MyVariables.foodManager.user?.address
        orderButton.layer.cornerRadius = 15
        changeButton.layer.cornerRadius = 10
        
        detailsView.clipsToBounds = true
        detailsView.layer.cornerRadius = 70
        detailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func refreshView() {
        
        var totalPrice = 0
        
        for dish in MyVariables.foodManager.basketDishes {
            totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
        }
        
        addressLabel.text = MyVariables.foodManager.user!.address
        
        priceLabel.text = "\(totalPrice) KM"
        
        basketTableView.reloadData()
    }
    
    private func registerCells() {
        basketTableView.register(UINib(nibName: BasketFoodCollectionViewCell.identifier, bundle: nil), forCellReuseIdentifier: BasketFoodCollectionViewCell.identifier)
    }
}
