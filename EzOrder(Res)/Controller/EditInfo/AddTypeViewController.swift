//
//  addClassificationViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/5/29.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddTypeViewController: UIViewController{
    
    @IBOutlet weak var foodNameTextfield: UITextField!
    @IBOutlet weak var foodImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let imagePickerContorller = UIImagePickerController()
        imagePickerContorller.sourceType = .photoLibrary
        imagePickerContorller.delegate = self
        //imagePickerContorller.allowsEditing = true
        present(imagePickerContorller,animated: true)
    }
    
    @IBAction func addImageVIews(_ sender: Any) {
        dismiss(animated: true)
        upload()
    }
    
    @IBAction func backVIew(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func upload() {
        SVProgressHUD.show()
        //  照片賦予生命
        if let foodName = foodNameTextfield.text, foodName.isEmpty == false{
            //DocumentReference 指定位置
            //照片參照
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            if let image = self.foodImageView.image{
                let size = CGSize(width: 640, height:
                    image.size.height * 640 / image.size.width)
                UIGraphicsBeginImageContext(size)
                image.draw(in: CGRect(origin: .zero, size: size))
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
//                        let db = Firestore.firestore()
//                        let userID = Auth.auth().currentUser!.email!
//                        let data: [String:Any] = ["Label" : foodName]
//                        let data: [String: Any] = ["documentID": foodName, "date": Date(), "dateString": self.todayDateString, "photoUrl": downloadURL.absoluteString, "title": self.titleTextField.text!, "mood": self.rate, "diaryText": self.diaryTextView.text!]
//                        db.collection(userID).document("LifeStory").collection("diaries").document(timeStamp).setData(data, completion: { (error) in
//                            guard error == nil else {
//                                SVProgressHUD.dismiss()
//                                return
//                            }
//                            SVProgressHUD.dismiss()
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                        SVProgressHUD.dismiss()
//                        photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
//                        self.navigationController?.popViewController(animated: true)
                    }
                        
                    )}
                    
                }
            }
        }
    }
        
            
            
//            photoReference = db.collection("photo").addDocument(data: data){
//                (error) in
//                guard error == nil  else {
//                    SVProgressHUD.show()
//                    return
//                }
//                let storageReference = Storage.storage().reference()
//                let fileReference = storageReference.child(UUID().uuidString + ".jpg")
//                let image = self.foodImageView.image
//                let size = CGSize(width: 640, height:
//                    image!.size.height * 640 / image!.size.width)
//                UIGraphicsBeginImageContext(size)
//                image?.draw(in: CGRect(origin: .zero, size: size))
//                let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//                if let data = resizeImage?.jpegData(compressionQuality: 0.8)
//                { fileReference.putData(data,metadata: nil) {(metadate , error) in
//                    guard let _ = metadate, error == nil else {
//                        SVProgressHUD.dismiss()
//                        return
//                    }
//                    fileReference.downloadURL(completion: { (url, error) in
//                        guard let downloadURL = url else {
//                            self.foodImageView.stopAnimating()
//                            return
//                        }
//                        photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
//                        self.navigationController?.popViewController(animated: true)
//                    }
//
//                    )}
//
//                }
//
//            }
//        }
        
        
//    }
    
}

extension AddTypeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selece = info[.originalImage] as? UIImage {
            foodImageView.image = selece
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
