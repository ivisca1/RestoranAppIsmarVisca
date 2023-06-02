//
//  FoodManager.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 31. 5. 2023..
//

import Foundation
import FirebaseFirestore

protocol FoodManagerDelegate {
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish])
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory])
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish])
    func didFailWithError(error: Error)
}

class FoodManager {
    let db = Firestore.firestore()
    
    var categories = [DishCategory]()
    
    var popularDishes = [FoodDish]()
    
    var restDishes = [FoodDish]()
    
    var allDishes = [FoodDish]()
    
    var searchDishes = [FoodDish]()
    
    var delegate : FoodManagerDelegate?
    
    init() {
        db.collection("food").getDocuments()  { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.allDishes.append(FoodDish(id: document.data()["id"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, price: document.data()["price"] as! String, description: document.data()["description"] as! String, categoryId: document.data()["categoryId"] as! String, popular: document.data()["popular"] as! Bool))
                }
                self.fetchFood(document: "food", categoryId: "1")
            }
        }
    }
    
    func fetchCategories(document: String) {
        db.collection(document).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.categories.append(DishCategory(id: document.data()["id"] as! String, name: document.data()["name"] as! String, image: document.data()["image"] as! String))
                }
                self.categories.sort {
                    $0.id < $1.id
                }
                self.delegate?.didUpdateCategories(self, categoriesList: self.categories)
            }
        }
    }
    
    func fetchFood(document: String, categoryId: String) {
        popularDishes.removeAll()
        restDishes.removeAll()
        popularDishes = allDishes.filter {
            $0.categoryId == categoryId && $0.popular == true
        }
        restDishes = allDishes.filter {
            $0.categoryId == categoryId && $0.popular == false
        }
        self.delegate?.didUpdateDishes(self, popularDishes: popularDishes, restDishes: restDishes)
    }
    
    func fetchFoodSearch(document: String, searchText: String) {
        searchDishes.removeAll()
        searchDishes = allDishes.filter {
            $0.name.lowercased().contains(searchText.lowercased()) || $0.name.contains(searchText)
        }
        delegate?.didUpdateSearch(self, dishes: searchDishes)
    }
}
