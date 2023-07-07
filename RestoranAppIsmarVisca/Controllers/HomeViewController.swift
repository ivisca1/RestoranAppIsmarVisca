//
//  HomeViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var promotionCollectionView: UICollectionView!
    @IBOutlet weak var specialsCollectionView: UICollectionView!
    @IBOutlet weak var popularDishesCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var indexCategory = 0
    var runAnimation = true
    var moveRight = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyVariables.foodManager.delegate = self
        MyVariables.foodManager.fetchCategories(document: "categories")
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 36)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.831, green: 0.765, blue: 0.51, alpha: 1.0)]
        
        registerCells()
        
        MyVariables.foodManager.isAnyoneSignedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        if MyVariables.foodManager.user != nil {
            self.updateBasketBadge()
        }
        
        if MyVariables.foodManager.user != nil && MyVariables.foodManager.ordered {
            MyVariables.foodManager.isOrderDelivered()
        }
        
        runAnim()
        runAnimation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        runAnimation = false
    }
    
    private func registerCells() {
        promotionCollectionView.register(UINib(nibName: PromotionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PromotionViewCell.identifier)
        categoryCollectionView.register(UINib(nibName: CategoryViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        popularDishesCollectionView.register(UINib(nibName: HomeFoodViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeFoodViewCell.identifier)
        specialsCollectionView.register(UINib(nibName: HomeFoodViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeFoodViewCell.identifier)
    }

}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return MyVariables.foodManager.categories.count
        case popularDishesCollectionView:
            return MyVariables.foodManager.popularDishes.count
        case specialsCollectionView:
            return MyVariables.foodManager.restDishes.count
        case promotionCollectionView:
            return MyVariables.promotions.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
            if(indexPath.row == indexCategory) {
                cell.setup(category: MyVariables.foodManager.categories[indexPath.row], redBackground: false)
            } else {
                cell.setup(category: MyVariables.foodManager.categories[indexPath.row], redBackground: true)
            }
            return cell
        case popularDishesCollectionView:
            let cell = popularDishesCollectionView.dequeueReusableCell(withReuseIdentifier: HomeFoodViewCell.identifier, for: indexPath) as! HomeFoodViewCell
            cell.setup(foodDish: MyVariables.foodManager.popularDishes[indexPath.row])
            return cell
        case specialsCollectionView:
            let cell = specialsCollectionView.dequeueReusableCell(withReuseIdentifier: HomeFoodViewCell.identifier, for: indexPath) as! HomeFoodViewCell
            cell.setup(foodDish: MyVariables.foodManager.restDishes[indexPath.row])
            return cell
        case promotionCollectionView:
            let cell = promotionCollectionView.dequeueReusableCell(withReuseIdentifier: PromotionViewCell.identifier, for: indexPath) as! PromotionViewCell
            cell.setup(promotion: MyVariables.promotions[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            MyVariables.foodManager.fetchFood(document: "food", categoryId: MyVariables.foodManager.categories[indexPath.row].id)
            indexCategory = indexPath.row
            categoryCollectionView.reloadData()
        } else if collectionView == popularDishesCollectionView {
            let controller = DishDetailViewController.instantiate()
            controller.dish = MyVariables.foodManager.popularDishes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else if collectionView == specialsCollectionView {
            let controller = DishDetailViewController.instantiate()
            controller.dish = MyVariables.foodManager.restDishes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            runAnimation = false
            if indexPath.row == 0 {
                instagramTap()
            } else if indexPath.row == 1 {
                facebookTap()
            } else {
                phoneDial()
            }
        }
    }
}

extension HomeViewController : FoodManagerDelegate {
    
    func didDeliverOrder(_ foodManager: FoodManager) {
        let controller = BasketViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
        self.updateBasketBadge()
    }
    
    func didMakeOrder(_ foodManager: FoodManager) {
        let controller = BasketOrderViewController.instantiate()
        controller.address = MyVariables.foodManager.user?.address
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
    }
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        if user != nil {
            tabBarController?.viewControllers?.removeLast()
            let controller = UserProfileNavigationController.instantiate()
            tabBarController?.viewControllers?.append(controller)
        } else {
            tabBarController?.viewControllers?.remove(at: 2)
            tabBarController?.viewControllers?.insert(NoBasketNavigationViewController.instantiate(), at: 2)
        }
    }
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {
        categoryCollectionView.reloadData()
    }
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {
        popularDishesCollectionView.reloadData()
        specialsCollectionView.reloadData()
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        self.updateBasketBadge()
    }
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didFailWithError(error: String) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
}

extension HomeViewController {
    
    func runAnim() {
        
        let dur: Double = 1
        
        let ptsPerSecond: Double = 10

        let animator = UIViewPropertyAnimator(duration: dur, curve: .linear) {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            if self.promotionCollectionView.contentOffset.x >= (1147 - screenWidth - ptsPerSecond * dur) {
                self.moveRight = false
            } else if self.promotionCollectionView.contentOffset.x < 0 {
                self.moveRight = true
            }
            if self.moveRight {
                self.promotionCollectionView.contentOffset.x += ptsPerSecond * dur
            } else {
                self.promotionCollectionView.contentOffset.x -= ptsPerSecond * dur
            }
        }
        
        animator.addCompletion({_ in
            if self.runAnimation {
                self.runAnim()
            }
        })
        
        animator.startAnimation()
    }
    
    private func instagramTap() {
        
        let username =  "instagram"
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
    }
    
    private func facebookTap() {
        
        let username =  "Facebook"
        let appURL = URL(string: "fb://profile/\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://m.facebook.com/\(username)")!
            application.open(webURL)
        }
    }
    
    private func phoneDial() {
        
        let phoneNumber = "+38761123456"
        let numberUrl = URL(string: "tel://\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        }
    }
}
