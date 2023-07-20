//
//  ReservationDetailsViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 20. 7. 2023..
//

import UIKit
import Toast

class ReservationDetailsViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var day : Int!
    var month : Int!
    var year: Int!
    var hours: Int!
    var numberOfPeople: Int!
    var comment: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.layer.cornerRadius = 15
        detailsView.layer.cornerRadius = 20
        
        dateLabel.text = "\(day!)/\(month!)/\(year!)"
        timeLabel.text = "\(hours!):00"
        numberOfPeopleLabel.text = "\(numberOfPeople!)"
        nameSurnameLabel.text = "\(MyVariables.foodManager.user!.name) \(MyVariables.foodManager.user!.surname)"
        commentLabel.text = comment
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        let date = Date()
        let components = Calendar.current.dateComponents([.year, .day, .month], from: date)
        let currentYear = components.year!
        let currentDay = components.day!
        let currentMonth = components.month!
        if currentDay == day && currentMonth == month && currentYear == year {
            view.makeToast("Ne možete otkazati rezervaciju danas.", duration: 1.0, position: .bottom)
        } else {
            MyVariables.foodManager.cancelReservation()
        }
    }
}

extension ReservationDetailsViewController : FoodManagerDelegate {
    
    func didUpdateUser(_ foodManager: FoodManager) {
        let controller = ReservationsViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 3)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?[3]
        tabBarController?.viewControllers?.remove(at: 4)
    }
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {}
    func didMakeReservation(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}
