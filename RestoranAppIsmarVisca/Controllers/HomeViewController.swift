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
    
    var categories = [DishCategory]()
    
    var populars = [FoodDish]()
    
    var restOfTheDishes = [FoodDish]()
    
    var foodManager = FoodManager()
    
    var index = 0
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodManager.delegate = self
        foodManager.fetchCategories(document: "categories")
        foodManager.fetchFood(document: "food", categoryId: "1")

        promotionView.layer.cornerRadius = 20
        registerCells()
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
                destinationVC.image = populars[index].image
                destinationVC.name = populars[index].name
                destinationVC.price = populars[index].price
                destinationVC.desc = populars[index].description
            } else {
                destinationVC.image = restOfTheDishes[index].image
                destinationVC.name = restOfTheDishes[index].name
                destinationVC.price = restOfTheDishes[index].price
                destinationVC.desc = restOfTheDishes[index].description
            }
        }
    }

}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return categories.count
        case popularDishesCollectionView:
            return populars.count
        case specialsCollectionView:
            return restOfTheDishes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case popularDishesCollectionView:
            let cell = popularDishesCollectionView.dequeueReusableCell(withReuseIdentifier: HomeFoodViewCell.identifier, for: indexPath) as! HomeFoodViewCell
            cell.setup(foodDish: populars[indexPath.row])
            return cell
        case specialsCollectionView:
            let cell = specialsCollectionView.dequeueReusableCell(withReuseIdentifier: HomeFoodViewCell.identifier, for: indexPath) as! HomeFoodViewCell
            cell.setup(foodDish: restOfTheDishes[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            
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
        categories = categoriesList.sorted {
            $0.id < $1.id
        }
        categoryCollectionView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {
        populars = popularDishes.sorted {
            $0.id < $1.id
        }
        popularDishesCollectionView.reloadData()
        
        restOfTheDishes = restDishes.sorted {
            $0.id < $1.id
        }
        specialsCollectionView.reloadData()
    }
}
