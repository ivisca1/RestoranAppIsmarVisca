//
//  FoodManager.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 31. 5. 2023..
//

import Foundation
import FirebaseFirestore

protocol FoodManagerDelegate {
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory])
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish])
    func didFailWithError(error: Error)
}

class FoodManager {
    let db = Firestore.firestore()
    
    var categories = [DishCategory]()
    
    var popularDishes = [FoodDish]()
    
    var restDishes = [FoodDish]()
    
    var delegate : FoodManagerDelegate?
    
    func fetchCategories(document: String) {
        db.collection(document).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.categories.append(DishCategory(id: document.data()["id"] as! String, name: document.data()["name"] as! String, image: document.data()["image"] as! String))
                }
                self.delegate?.didUpdateCategories(self, categoriesList: self.categories)
            }
        }
    }
    
    func fetchFood(document: String, categoryId: String) {
        popularDishes.removeAll()
        restDishes.removeAll()
        db.collection(document).whereField("categoryId", isEqualTo: categoryId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["popular"] as! Bool == true {
                        self.popularDishes.append(FoodDish(id: document.data()["id"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, price: document.data()["price"] as! String, description: document.data()["description"] as! String, categoryId: document.data()["categoryId"] as! String, popular: document.data()["popular"] as! Bool))
                    } else {
                        self.restDishes.append(FoodDish(id: document.data()["id"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, price: document.data()["price"] as! String, description: document.data()["description"] as! String, categoryId: document.data()["categoryId"] as! String, popular: document.data()["popular"] as! Bool))
                    }
                }
                self.delegate?.didUpdateDishes(self, popularDishes: self.popularDishes, restDishes: self.restDishes)
            }
    }
    }
}
