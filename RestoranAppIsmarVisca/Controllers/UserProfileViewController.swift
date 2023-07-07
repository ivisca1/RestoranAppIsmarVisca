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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        MyVariables.foodManager.getProfilePicture()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
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

    @IBAction func logOutClicked(_ sender: UIButton) {
        MyVariables.foodManager.logOutUser()
    }
    @IBAction func changeDetailsClicked(_ sender: UIButton) {
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
        tabBarController?.viewControllers?.append(NoBasketNavigationViewController.instantiate())
        tabBarController?.viewControllers?.append(ProfileNavigationViewController.instantiate())
        tabBarController?.selectedViewController = tabBarController?.viewControllers?.last
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
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
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


