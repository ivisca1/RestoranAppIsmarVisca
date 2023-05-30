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
    
    var categories : [DishCategory] = [
        .init(id: "1", name: "Roštilj", image: "burger"),
        .init(id: "2", name: "Pizza", image: "margarita"),
        .init(id: "3", name: "Dezert", image: "sladoled")
    ]
    
    var populars : [FoodDish] = [
        .init(id: "1", image: "burger", name: "Hamburger", price: "12 KM"),
        .init(id: "1", image: "margarita", name: "Margarita", price: "8 KM"),
        .init(id: "1", image: "sladoled", name: "Sladoled", price: "5 KM"),
        .init(id: "1", image: "pomfrit", name: "Pomfrit", price: "2 KM")
    ]
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            destinationVC.image = populars[index].image
            destinationVC.name = populars[index].name
            destinationVC.price = populars[index].price
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
            return populars.count
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
            cell.setup(foodDish: populars[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            populars.append(FoodDish(id: "5", image: "burger", name: "svasta", price: "5 KM"))
            popularDishesCollectionView.reloadData()
        } else {
            index = indexPath.row
            performSegue(withIdentifier: "goToDishDetail", sender: collectionView)
        }
    }
}
