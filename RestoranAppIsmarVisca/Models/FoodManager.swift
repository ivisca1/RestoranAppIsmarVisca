//
//  FoodManager.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 31. 5. 2023..
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FoodManagerDelegate {
    func didLogOutUser(_ foodManager: FoodManager)
    func didSignInUser(_ foodManager: FoodManager, user: User?)
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish])
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
    
    var basketDishes = [FoodDish]()
    
    var delegate : FoodManagerDelegate?
    
    var user : User?
    
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
    
    func addToBasket(dishName: String) {
        basketDishes.append(allDishes.first {
            $0.name == dishName
        }!)
        db.collection("orders").whereField("email", isEqualTo: user?.email ?? "a").getDocuments { (result, error) in
            if error == nil{
                for document in result!.documents{
                    self.db.collection("orders").document(document.documentID).setData([ "food": FieldValue.arrayUnion([dishName]) ], merge: true)
                }
            }
        }
        delegate?.didUpdateBasket(self, dishes: basketDishes)
    }
    
    func removeFromBasket(index: Int) {
        let dishName = basketDishes[index].name
        basketDishes.remove(at: index)
        db.collection("orders").whereField("email", isEqualTo: user?.email ?? "a").getDocuments { (result, error) in
            if error == nil{
                for document in result!.documents{
                    self.db.collection("orders").document(document.documentID).setData([ "food": FieldValue.arrayRemove([dishName]) ], merge: true)
                    break
                }
            }
        }
        delegate?.didUpdateBasket(self, dishes: basketDishes)
    }
    
    func createUser(userToCreate : User, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: userToCreate.email, password: password, completion: { result, error in
            if error != nil {
                print(error!)
            }
            else {
                self.db.collection("users").document(userToCreate.email).setData([
                    "name": userToCreate.name,
                    "surname": userToCreate.surname,
                    "email": userToCreate.email,
                    "address": userToCreate.address,
                    "phoneNumber": userToCreate.phoneNumber
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.user = userToCreate
                        self.delegate?.didSignInUser(self, user: userToCreate)
                    }
                }
            }
        })
    }
    
    func logInUser(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,completion: { result, error in
            if error != nil {
                print(error!)
            }
            else {
                self.db.collection("users").whereField("email", isEqualTo: email)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let foundUser = querySnapshot?.documents[0]
                            self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String)
                            self.delegate?.didSignInUser(self, user: self.user!)
                        }
                }
            }
        })
    }
    
    func logOutUser() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            user = nil
            self.delegate?.didLogOutUser(self)
        } catch {
            print("An error occurred")
        }
    }
    
    func isAnyoneSignedIn() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            self.db.collection("users").whereField("email", isEqualTo: FirebaseAuth.Auth.auth().currentUser?.email! ?? "a")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let foundUser = querySnapshot?.documents[0]
                        self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String)
                        self.delegate?.didSignInUser(self, user: self.user!)
                        self.fetchBasket()
                    }
            }
        } else {
            self.delegate?.didSignInUser(self, user: nil)
        }
    }
    
    func fetchBasket() {
        basketDishes.removeAll()
        if user != nil {
            db.collection("orders").whereField("email", isEqualTo: user?.email ?? "a")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if (querySnapshot?.documents.count)! > 0 {
                            let foundOrder = querySnapshot?.documents[0]
                            self.db.collection("food").whereField("name", in: foundOrder?.data()["food"] as! [String]).getDocuments() { (querySnapshot2, err2) in
                                if let err = err2 {
                                    print("Error getting documents: \(err)")
                                } else {
                                    for document in querySnapshot2!.documents {
                                        self.basketDishes.append(FoodDish(id: document.data()["id"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, price: document.data()["price"] as! String, description: document.data()["description"] as! String, categoryId: document.data()["categoryId"] as! String, popular: document.data()["popular"] as! Bool))
                                    }
                                    self.delegate?.didUpdateBasket(self, dishes: self.basketDishes)
                                }
                            }
                        } else {
                            self.delegate?.didUpdateBasket(self, dishes: self.basketDishes)
                        }
                    }
            }
        }
    }
}
