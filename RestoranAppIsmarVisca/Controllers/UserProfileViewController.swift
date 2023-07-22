//
//  UserProfileViewController.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 9. 6. 2023..
//

import UIKit
import RSKImageCropper

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyVariables.foodManager.fetchBasket()
        
        MyVariables.foodManager.fetchReservation()
        
        setUpEverything()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        refreshView()
    }

    @IBAction func logOutClicked(_ sender: UIButton) {
        MyVariables.foodManager.logOutUser()
    }
    
    @IBAction func changeDetailsClicked(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        let controller = ChangeUserDetailsViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension UserProfileViewController : FoodManagerDelegate {
    
    func didDeliverOrder(_ foodManager: FoodManager) {
        let controller = BasketViewController.instantiate()
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
        self.updateBasketBadge()
    }
    
    func didLogOutUser(_ foodManager: FoodManager) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noReservationController = storyboard.instantiateViewController(identifier: "NoReservationNavigationController")
        tabBarController?.viewControllers?.append(NoBasketNavigationViewController.instantiate())
        tabBarController?.viewControllers?.append(noReservationController)
        tabBarController?.viewControllers?.append(ProfileNavigationViewController.instantiate())
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
        tabBarController?.viewControllers?.remove(at: 2)
    }
    
    func didUpdateBasket(_ foodManager: FoodManager, dishes: [FoodDish]) {
        self.updateBasketBadge()
    }
    
    func didMakeOrder(_ foodManager: FoodManager) {
        let controller = BasketOrderViewController.instantiate()
        controller.address = MyVariables.foodManager.user?.address
        tabBarController?.viewControllers?.insert(controller, at: 2)
        tabBarController?.viewControllers?.remove(at: 3)
    }
    
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {
        profileImageView.image = MyVariables.foodManager.image
    }
    
    func didFetchReservation(_ foodManager: FoodManager, day: Int, month: Int, year: Int, hours: Int, numberOfPeople: Int, comment: String) {
        let controller = ReservationDetailsViewController.instantiate()
        
        controller.day = day
        controller.month = month
        controller.year = year
        controller.hours = hours
        controller.numberOfPeople = numberOfPeople
        controller.comment = comment
        
        tabBarController?.viewControllers?.insert(controller, at: 3)
        tabBarController?.viewControllers?.remove(at: 4)
    }
    
    func didMakeReservation(_ foodManager: FoodManager) {}
    func didUpdateSearch(_ foodManager: FoodManager, dishes: [FoodDish]) {}
    func didUpdateCategories(_ foodManager: FoodManager, categoriesList: [DishCategory]) {}
    func didUpdateDishes(_ foodManager: FoodManager, popularDishes: [FoodDish], restDishes: [FoodDish]) {}
    func didFailWithError(error: String) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
}

extension UserProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Očekivana je slika, ali je dostavljeno sljedeće:: \(info)")
        }
        
        picker.dismiss(animated: false, completion: { () -> Void in

            var imageCropVC : RSKImageCropViewController!

            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)

            imageCropVC.delegate = self

            self.navigationController?.pushViewController(imageCropVC, animated: true)

        })
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        navigationController?.popViewController(animated: true)
    }

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        profileImageView.image = croppedImage
        MyVariables.foodManager.uploadProfilePicture(image: croppedImage)
        navigationController?.popViewController(animated: true)
    }
}

extension UserProfileViewController {
    
    private func setUpEverything() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        profileImageView.image = MyVariables.foodManager.image
        
        MyVariables.foodManager.getProfilePicture()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        profileImageView.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.profileImageView.alpha = 1
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func refreshView() {
        
        let user = MyVariables.foodManager.user!
        
        nameSurnameLabel.text = "\(user.name) \(user.surname)"
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        addressLabel.text = user.address
        
        if MyVariables.foodManager.user != nil {
            self.updateBasketBadge()
        }
        
        if MyVariables.foodManager.user != nil && MyVariables.foodManager.ordered {
            MyVariables.foodManager.isOrderDelivered()
        }
    }
}
