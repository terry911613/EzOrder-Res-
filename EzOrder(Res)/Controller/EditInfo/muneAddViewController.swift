//
//  muneAddViewController.swift
//
//
//  Created by 劉十六 on 2019/6/2.
//

import UIKit
import Firebase
class muneAddViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var foodMuneImage: UIImageView!
    @IBOutlet weak var foodMuneName: UITextField!
    @IBOutlet weak var foodMuneMoney: UITextField!
    var an = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backDiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addMune(_ sender: Any) {
        upload()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapMunefoodImage(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker,animated: true)
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selece = info[.originalImage] as! UIImage
        foodMuneImage.image = selece
        picker.dismiss(animated: true, completion: nil)
    }
    
    func upload()   {
        foodMuneImage.startAnimating()
        //  照片賦予生命
        let foodNames = foodMuneName.text ?? ""
        let foodMoneys = foodMuneMoney.text ?? ""
        let db = Firestore.firestore()
        let dats: [String:Any] = ["Name" : foodNames,"Money" : foodMoneys]
        
        var photoReference : DocumentReference?
        //var proor : DocumentChange
        //DocumentReference 指定位置
        //照片參照
        
        //  let data = ["date": Date()]
        photoReference =  db.collection("photo").document(an).collection("Munes").addDocument(data: dats) { (error) in
            guard error == nil  else {
                self.foodMuneImage.startAnimating()
                return
            }
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let image = self.foodMuneImage.image
            let size = CGSize(width: 640, height:
                image!.size.height * 640 / image!.size.width)
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let data = resizeImage?.jpegData(compressionQuality: 0.8)
            { fileReference.putData(data,metadata: nil) {(metadate , error) in
                guard let _ = metadate, error == nil else {
                    self.foodMuneImage.stopAnimating()
                    return
                }
                fileReference.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                        self.foodMuneImage.stopAnimating()
                        return
                    }
                    photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                }
                    
                )}
                
                
            }
            
        }
        
    }
    
}

