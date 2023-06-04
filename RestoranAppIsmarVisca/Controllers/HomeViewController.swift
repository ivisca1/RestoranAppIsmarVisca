//
//  HomeViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 24. 5. 2023..
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var specialsCollectionView: UICollectionView!
    @IBOutlet weak var popularDishesCollectionView: UICollectionView!
    @IBOutlet weak var promotionView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var index = 0
    var indexCategory = 0
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyVariables.foodManager.delegate = self
        MyVariables.foodManager.fetchCategories(document: "categories")

        promotionView.layer.cornerRadius = 20
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        let tabBar = self.tabBarController!.tabBar
        let basketItem = tabBar.items![2]
        basketItem.badgeColor = UIColor.red
        basketItem.badgeValue = "\(MyVariables.foodManager.basketDishes.count)"
    }
    
    private func registerCells() {
        categoryCollectionView.register(UINib(nibName: CategoryViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        popularDishesCollectionView.register(UINib(nibName: HomeFoodViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeFoodViewCell.identifier)
        specialsCollectionView.register(UINib(nibName: HomeFoodViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeFoodViewCell.identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDishDetail" {
            let destinationVC = segue.destination as! DishDetailViewController
            if temp == 0 {
                destinationVC.image = MyVariables.foodManager.popularDishes[index].image
                destinationVC.name = MyVariables.foodManager.popularDishes[index].name
                destinationVC.price = MyVariables.foodManager.popularDishes[index].price
                destinationVC.desc = MyVariables.foodManager.popularDishes[index].description
            } else {
                destinationVC.image = MyVariables.foodManager.restDishes[index].image
                destinationVC.name = MyVariables.foodManager.restDishes[index].name
                destinationVC.price = MyVariables.foodManager.restDishes[index].price
                destinationVC.desc = MyVariables.foodManager.restDishes[index].description
            }
        }
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
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
            if(indexPath.row == indexCategory) {
                cell.setup(category: MyVariables.foodManager.categories[indexPath.row], redBackground: true)
            } else {
                cell.setup(category: MyVariables.foodManager.categories[indexPath.row], redBackground: false)
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
            index = indexPath.row
            temp = 0
            performSegue(withIdentifier: "goToDishDetail", sender: collectionView)
        } else {
            index = indexPath.row
            temp = 1
            performSegue(withIdentifier: "goToDishDetail", sender: collectionView)
        }
    }
}

extension HomeViewController : FoodManagerDelegate {
    
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {
        categoryCollectionView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {
        popularDishesCollectionView.reloadData()
        specialsCollectionView.reloadData()
    }
    
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {}
}
