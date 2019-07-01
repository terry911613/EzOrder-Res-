//
//  muneAddViewController.swift
//
//
//  Created by 劉十六 on 2019/6/2.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class FoodViewController: UIViewController{
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextfield: UITextField!
    @IBOutlet weak var foodPriceTextfield: UITextField!
    @IBOutlet weak var foodDetailTextfield: UITextView!
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var typeArray = [QueryDocumentSnapshot]()
    var typeIndex: Int?
    var foodIndex: Int?
    var foodName: String?
    var foodImage: String?
    var foodPrice: Int?
    var foodDetail: String?
    var typeDocumentID: String?
    var viewHeight: CGFloat?
    weak var delegate: EditMenuViewController?
    var isEdit = false
    var foodDocumentID: String?
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let foodImage = foodImage,
            let foodName = foodName,
            let foodPrice = foodPrice,
            let foodDetail = foodDetail{
            
            foodImageView.kf.setImage(with: URL(string: foodImage))
            foodNameTextfield.text = foodName
            foodPriceTextfield.text = String(foodPrice)
            foodDetailTextfield.text = foodDetail
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if isEdit{
            editUpload()
        }
        else{
            upload()
        }
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func tapMunefoodImage(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker,animated: true)
    }
    
    func editUpload(){
        if let foodImage = foodImageView.image,
            let foodName = foodNameTextfield.text, foodName.isEmpty == false,
            let foodPrice = Int(foodPriceTextfield.text!),
            let resID = resID,
            let typeIndex = typeIndex,
            let typeDocumentID = self.typeArray[typeIndex].data()["typeDocumentID"] as? String,
            let foodDocumentID = foodDocumentID{
            //DocumentReference 指定位置
            //照片參照
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: foodImage.size.height * 640 / foodImage.size.width)
            UIGraphicsBeginImageContext(size)
            foodImage.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let data = resizeImage?.jpegData(compressionQuality: 0.8){
                fileReference.putData(data,metadata: nil) {(metadate, error) in
                    guard let _ = metadate, error == nil else {
                        SVProgressHUD.dismiss()
                        return
                    }
                    fileReference.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {
                            SVProgressHUD.dismiss()
                            return
                        }
                        let data: [String: Any] = ["foodName": foodName,
                                                   "foodImage": downloadURL.absoluteString,
                                                   "foodPrice": foodPrice,
                                                   "foodDetail": self.foodDetailTextfield.text ?? ""]
                        self.db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).updateData(data, completion: { (error) in
                            guard error == nil else {
                                SVProgressHUD.dismiss()
                                return
                            }
                            self.delegate?.getFood(typeDocumentID: typeDocumentID)
                            SVProgressHUD.dismiss()
                        })
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    
    func upload(){
        
        if let foodImage = foodImageView.image,
            let foodName = foodNameTextfield.text, foodName.isEmpty == false,
            let foodPrice = Int(foodPriceTextfield.text!),
            let resID = resID,
            let foodIndex = foodIndex,
            let typeIndex = typeIndex,
            let typeDocumentID = self.typeArray[typeIndex].data()["typeDocumentID"] as? String{
            //DocumentReference 指定位置
            //照片參照
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: foodImage.size.height * 640 / foodImage.size.width)
            UIGraphicsBeginImageContext(size)
            foodImage.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let data = resizeImage?.jpegData(compressionQuality: 0.8){
                fileReference.putData(data,metadata: nil) {(metadate, error) in
                    guard let _ = metadate, error == nil else {
                        SVProgressHUD.dismiss()
                        return
                    }
                    fileReference.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {
                            SVProgressHUD.dismiss()
                            return
                        }
                        let documentID = String(Date().timeIntervalSince1970) + resID
                        let data: [String: Any] = ["foodDocumentID": documentID,
                                                   "typeIndex": typeIndex,
                                                   "typeDocumentID": typeDocumentID,
                                                   "foodName": foodName,
                                                   "foodImage": downloadURL.absoluteString,
                                                   "foodPrice": foodPrice,
                                                   "foodIndex": foodIndex,
                                                   "foodStatus": 1,
                                                   "foodRateCount": 0,
                                                   "foodTotalRate": 0,
                                                   "foodDetail": self.foodDetailTextfield.text ?? ""]
                        self.db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(documentID).setData(data, completion: { (error) in
                            guard error == nil else {
                                SVProgressHUD.dismiss()
                                return
                            }
                            self.delegate?.getFood(typeDocumentID: typeDocumentID)
                            SVProgressHUD.dismiss()
                        })
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension FoodViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selece = info[.originalImage] as! UIImage
        foodImageView.image = selece
        picker.dismiss(animated: true, completion: nil)
    }
}
extension FoodViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        viewHeight = view.frame.height
        let alertViewHeight = self.alertView.frame.height
        let alertViewLeftBottomY = alertView.frame.origin.y + alertViewHeight
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            
            let overlap = alertViewLeftBottomY + keyboardRect.height - viewHeight!
            if overlap > -10 {
                view.frame.origin.y = -(overlap + 10)
            }
        } else {
            view.frame.origin.y = -view.frame.height / 5
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
