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
    func didUpdateUser(_ foodManager: FoodManager)
    func didDeliverOrder(_ foodManager: FoodManager)
    func didMakeOrder(_ foodManager: FoodManager)
    func didLogOutUser(_ foodManager: FoodManager)
    func didSignInUser(_ foodManager: FoodManager, user: User?)
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish])
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish])
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory])
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish])
    func didFailWithError(error: String)
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
    
    var ordered = false
    
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
        db.collection("orders").whereField("email", isEqualTo: user!.email).whereField("ordered", isEqualTo: false).getDocuments { (result, error) in
            if error == nil{
                if result!.documents.count > 0 {
                    let order = self.db.collection("orders").document("\(self.user!.email)\(self.user!.orderNumber)")
                    order.getDocument { (document, error) in
                        if let document = document, document.exists {
                            var foodArray = document.data()!["food"] as! [String]
                            foodArray.append(dishName)
                            order.updateData([
                                "food": foodArray as Any
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                    self.user!.orderNumber = self.user!.orderNumber + 1
                    self.updateTodaysOrderNumber()
                    self.db.collection("orders").document("\(self.user!.email)\(self.user!.orderNumber)").setData([
                        "email": self.user!.email,
                        "address": self.user!.address,
                        "delivered": false,
                        "ordered": false,
                        "food": [dishName],
                        "orderNumber": self.user!.orderNumber
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
        delegate?.didUpdateBasket(self, dishes: basketDishes)
    }
    
    func removeFromBasket(index: Int) {
        let dishName = basketDishes[index].name
        basketDishes.remove(at: index)
        db.collection("orders").whereField("email", isEqualTo: user!.email).getDocuments { (result, error) in
            if error == nil{
                let order = self.db.collection("orders").document("\(self.user!.email)\(self.user!.orderNumber)")
                order.getDocument { (document, error) in
                    if let document = document, document.exists {
                        var foodArray = document.data()!["food"] as! [String]
                        var index = 0
                        for dish in foodArray {
                            if dish == dishName {
                                break
                            }
                            index = index + 1
                        }
                        foodArray.remove(at: index)
                        order.updateData([
                            "food": foodArray as Any
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
        delegate?.didUpdateBasket(self, dishes: basketDishes)
    }
    
    func createUser(userToCreate : User, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: userToCreate.email, password: password, completion: { result, error in
            if error != nil {
                let errCode = AuthErrorCode(_nsError: error! as NSError)
                var errorMsg = ""
                switch errCode.code {
                case .accountExistsWithDifferentCredential, .credentialAlreadyInUse, .emailAlreadyInUse:
                    errorMsg = "Profil sa ovim email-om već postoji!"
                default:
                    errorMsg = "Neuspješan Sign Up!"
                }
                self.delegate?.didFailWithError(error: errorMsg)
            }
            else {
                self.db.collection("users").document(userToCreate.email).setData([
                    "name": userToCreate.name,
                    "surname": userToCreate.surname,
                    "email": userToCreate.email,
                    "address": userToCreate.address,
                    "phoneNumber": userToCreate.phoneNumber,
                    "orderNumber": 0,
                    "isCustomer": true,
                    "isEmployee": false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.ordered = false
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
                let errCode = AuthErrorCode(_nsError: error! as NSError)
                var errorMsg = ""
                switch errCode.code {
                case .userNotFound:
                    errorMsg = "Korisnik nije pronađen. Prvo kreirajte profil!"
                case .wrongPassword:
                    errorMsg = "Šifra neispravna!"
                default:
                    errorMsg = "Neuspješan Log In!"
                }
                self.delegate?.didFailWithError(error: errorMsg)
            }
            else {
                self.db.collection("users").whereField("email", isEqualTo: email)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let foundUser = querySnapshot?.documents[0]
                            let isCustomer = foundUser?.data()["isCustomer"] as! Bool
                            if isCustomer {
                                self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String, orderNumber: foundUser?.data()["orderNumber"] as! Int, isCustomer: foundUser?.data()["isCustomer"] as! Bool, isEmployee: foundUser?.data()["isEmployee"] as! Bool)
                                self.delegate?.didSignInUser(self, user: self.user!)
                            } else {
                                let errorMsg = "Korisnik nije pronađen. Prvo kreirajte profil!"
                                self.delegate?.didFailWithError(error: errorMsg)
                            }
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
            self.db.collection("users").whereField("email", isEqualTo: FirebaseAuth.Auth.auth().currentUser!.email!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let foundUser = querySnapshot?.documents[0]
                        self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String, orderNumber: foundUser?.data()["orderNumber"] as! Int, isCustomer: foundUser?.data()["isCustomer"] as! Bool, isEmployee: foundUser?.data()["isEmployee"] as! Bool)
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
            db.collection("orders").whereField("email", isEqualTo: user!.email).whereField("orderNumber", isEqualTo: user!.orderNumber)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if (querySnapshot?.documents.count)! > 0 {
                            let foundOrder = querySnapshot?.documents[0]
                            let foodArray = foundOrder?.data()["food"] as! [String]
                            let isOrdered = foundOrder?.data()["ordered"] as! Bool
                            let isDelivered = foundOrder?.data()["delivered"] as! Bool
                            if isOrdered && isDelivered == false {
                                self.ordered = true
                                self.delegate?.didMakeOrder(self)
                            }
                            if foodArray.count > 0 && isDelivered == false {
                                self.db.collection("food").whereField("name", in: foundOrder?.data()["food"] as! [String]).getDocuments() { (querySnapshot2, err2) in
                                    if let err = err2 {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot2!.documents {
                                            for dish in foodArray {
                                                let name = document.data()["name"] as! String
                                                if dish == name {
                                                    self.basketDishes.append(FoodDish(id: document.data()["id"] as! String, image: document.data()["image"] as! String, name: document.data()["name"] as! String, price: document.data()["price"] as! String, description: document.data()["description"] as! String, categoryId: document.data()["categoryId"] as! String, popular: document.data()["popular"] as! Bool))
                                                }
                                            }
                                        }
                                        self.delegate?.didUpdateBasket(self, dishes: self.basketDishes)
                                    }
                                }
                            } else {
                                self.delegate?.didUpdateBasket(self, dishes: self.basketDishes)
                            }
                        } else {
                            self.delegate?.didUpdateBasket(self, dishes: self.basketDishes)
                        }
                    }
            }
        }
    }
    
    func makeOrder(newAddress: String) {
        let order = self.db.collection("orders").document("\(user!.email)\(user!.orderNumber)")
        order.getDocument { (document, error) in
            if let document = document, document.exists {
                self.ordered = true
                order.updateData([
                    "address": newAddress,
                    "ordered": true
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.delegate?.didMakeOrder(self)
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func isOrderDelivered() {
        db.collection("orders").whereField("email", isEqualTo: user!.email).getDocuments { (result, error) in
            if error == nil{
                let order = self.db.collection("orders").document("\(self.user!.email)\(self.user!.orderNumber)")
                order.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let delivered = document.data()?["delivered"] as! Bool
                        if delivered {
                            self.ordered = false
                            self.basketDishes.removeAll()
                            self.delegate?.didDeliverOrder(self)
                        }
                    }
                }
            }
        }
    }
    
    func updateUser(name: String, surname: String, phoneNumber: String, address: String) {
        user = User(name: name, surname: surname, phoneNumber: phoneNumber, email: user!.email, address: address, orderNumber: user!.orderNumber, isCustomer: user!.isCustomer, isEmployee: user!.isEmployee)
        db.collection("users").whereField("email", isEqualTo: user!.email).getDocuments { (result, error) in
            if error == nil{
                let foundUser = self.db.collection("users").document(self.user!.email)
                foundUser.getDocument { (document, error) in
                    if let document = document, document.exists {
                        foundUser.updateData([
                            "name": name,
                            "surname": surname,
                            "phoneNumber": phoneNumber,
                            "address": address
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                self.delegate?.didUpdateUser(self)
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func updateTodaysOrderNumber() {
        db.collection("users").whereField("email", isEqualTo: user!.email).getDocuments { (result, error) in
            if error == nil{
                let foundUser = self.db.collection("users").document(self.user!.email)
                foundUser.getDocument { (document, error) in
                    if let document = document, document.exists {
                        foundUser.updateData([
                            "orderNumber": self.user!.orderNumber
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                self.delegate?.didUpdateUser(self)
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
}
