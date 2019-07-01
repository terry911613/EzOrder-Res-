//
//  addClassificationViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/5/29.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class TypeViewController: UIViewController{
    
    @IBOutlet weak var typeNameTextfield: UITextField!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var alertView: UIView!
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var index: Int?
    var typeName: String?
    var typeImage: String?
    var viewHeight: CGFloat?
    var typeDocumentID: String?
    weak var delegate: EditMenuViewController?
    var isEdit = false
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let typeName = typeName,
            let typeImage = typeImage{
            typeNameTextfield.text = typeName
            typeImageView.kf.setImage(with: URL(string: typeImage))
        }
    }
    
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {
        let imagePickerContorller = UIImagePickerController()
        imagePickerContorller.sourceType = .photoLibrary
        imagePickerContorller.delegate = self
        //imagePickerContorller.allowsEditing = true
        present(imagePickerContorller,animated: true)
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
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func editUpload(){
        if let typeName = typeNameTextfield.text, typeName.isEmpty == false,
            let typeImage = typeImageView.image,
            let resID = resID,
            let documentID = typeDocumentID{
            
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: typeImage.size.height * 640 / typeImage.size.width)
            UIGraphicsBeginImageContext(size)
            typeImage.draw(in: CGRect(origin: .zero, size: size))
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
                        let data: [String: Any] = ["typeName": typeName,
                                                   "typeImage": downloadURL.absoluteString]
                        self.db.collection("res").document(resID).collection("foodType").document(documentID).updateData(data, completion: { (error) in
                            guard error == nil else {
                                SVProgressHUD.dismiss()
                                return
                            }
                            self.delegate?.getType()
                            SVProgressHUD.dismiss()
                        })
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    
    func upload() {
        if let typeName = typeNameTextfield.text, typeName.isEmpty == false,
            let typeImage = typeImageView.image,
            let resID = resID,
            let index = index{
            //DocumentReference 指定位置
            //照片參照
            SVProgressHUD.show()
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let size = CGSize(width: 640, height: typeImage.size.height * 640 / typeImage.size.width)
            UIGraphicsBeginImageContext(size)
            typeImage.draw(in: CGRect(origin: .zero, size: size))
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
                        let data: [String: Any] = ["typeDocumentID": documentID,
                                                   "typeName": typeName,
                                                   "typeImage": downloadURL.absoluteString,
                                                   "index": index]
                        self.db.collection("res").document(resID).collection("foodType").document(documentID).setData(data, completion: { (error) in
                            guard error == nil else {
                                SVProgressHUD.dismiss()
                                return
                            }
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

extension TypeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selece = info[.originalImage] as? UIImage {
            typeImageView.image = selece
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension TypeViewController {
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
