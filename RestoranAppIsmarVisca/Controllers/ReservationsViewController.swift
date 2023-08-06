//
//  ReservationsViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 19. 7. 2023..
//

import UIKit
import Toast

class ReservationsViewController: UIViewController {

    
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var numberOfPeopleSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var hours = 20
    var numberOfPeople = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reserveButton.layer.cornerRadius = 15
        commentTextView.layer.cornerRadius = 15
        
        datePicker.textColor = UIColor.white
        
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        timeSlider.addTarget(self, action: #selector(timeSliderValueDidChange(_:)), for: .valueChanged)
        
        numberOfPeopleSlider.addTarget(self, action: #selector(numberOfPeopleSliderValueDidChange(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }

    
    @IBAction func reserveButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.year, .day, .month], from: date)
        let year = components.year!
        let day = components.day!
        let month = components.month!
        MyVariables.foodManager.checkIfReservationIsAvailable(day: day, month: month, year: year, hours: hours, numberOfPeople: numberOfPeople, comment: commentTextView.text)
    }
    
}

extension ReservationsViewController : FoodManagerDelegate {
    
    func didMakeReservation(_ foodManager: FoodManager) {
        
        view.makeToast("Uspješna rezervacija", duration: 2.0, position: .bottom)
        
        let controller = ReservationDetailsViewController.instantiate()
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.year, .day, .month], from: date)
        let year = components.year!
        let day = components.day!
        let month = components.month!
        
        controller.day = day
        controller.month = month
        controller.year = year
        controller.hours = hours
        controller.numberOfPeople = numberOfPeople
        controller.comment = commentTextView.text
        
        tabBarController?.viewControllers?.insert(controller, at: 3)
        tabBarController?.selectedViewController = tabBarController?.viewControllers?[3]
        tabBarController?.viewControllers?.remove(at: 4)
    }
    
    func didFailWithError(error: String) {
        view.makeToast(error, duration: 2.0, position: .bottom)
    }
    
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didMakeOrder(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

extension ReservationsViewController {
    
    @objc func timeSliderValueDidChange(_ sender: UISlider) {
        print("\(sender.value)")
        if sender.value <= 16 {
            hours = 18
            sender.value = 0
        } else if sender.value > 16 && sender.value <= 41 {
            hours = 19
            sender.value = 26
        } else if sender.value > 41 && sender.value <= 58 {
            hours = 20
            sender.value = 50
        } else if sender.value > 58 && sender.value <= 83 {
            hours = 21
            sender.value = 76
        } else if sender.value > 83 {
            hours = 22
            sender.value = 100
        }
    }
    
    @objc func numberOfPeopleSliderValueDidChange(_ sender: UISlider) {
        print("\(sender.value)")
        if sender.value <= 16 {
            numberOfPeople = 1
            sender.value = 0
        } else if sender.value > 16 && sender.value <= 41 {
            numberOfPeople = 2
            sender.value = 19
        } else if sender.value > 41 && sender.value <= 58 {
            numberOfPeople = 3
            sender.value = 50
        } else if sender.value > 58 && sender.value <= 83 {
            numberOfPeople = 4
            sender.value = 81
        } else if sender.value > 83 {
            numberOfPeople = 5
            sender.value = 100
        }
    }
}
