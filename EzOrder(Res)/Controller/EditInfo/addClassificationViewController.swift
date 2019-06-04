//
//  addClassificationViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/5/29.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
class addClassificationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var foodName: UITextField!
    
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selece = info[.originalImage] as? UIImage {
        imageView.image = selece
        }
    picker.dismiss(animated: true, completion: nil)
            
    }
    @IBAction func TabUPImageView(_ sender: UITapGestureRecognizer) {
      let imagePickerContorller = UIImagePickerController()
        imagePickerContorller.sourceType = .photoLibrary
        imagePickerContorller.delegate = self
        //imagePickerContorller.allowsEditing = true
        present(imagePickerContorller,animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImageVIews(_ sender: Any) {
        dismiss(animated: true)
        upload()
    }
    
    @IBAction func backVIew(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func upload() {
        imageView.startAnimating()
        //  照片賦予生命
        let foodNames = foodName.text ?? ""
        let db = Firestore.firestore()
        let data: [String:Any] = ["Label" : foodNames]
        var photoReference : DocumentReference?
        //DocumentReference 指定位置
        //照片參照
        photoReference = db.collection("photo").addDocument(data: data){
            (error) in
            guard error == nil  else {
                self.imageView.startAnimating()
                return
            }
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let image = self.imageView.image
            let size = CGSize(width: 640, height:
                image!.size.height * 640 / image!.size.width)
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let data = resizeImage?.jpegData(compressionQuality: 0.8)
            { fileReference.putData(data,metadata: nil) {(metadate , error) in
                guard let _ = metadate, error == nil else {
                    self.imageView.stopAnimating()
                    return
                }
                fileReference.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                        self.imageView.stopAnimating()
                        return
                    }
                    photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                    self.navigationController?.popViewController(animated: true)
                }
                    
                )}
                
                
            }
            
        }
        
    }

    
    

}
