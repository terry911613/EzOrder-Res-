//
//  ViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class EditInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var foodName: UITextField!
    var photos = [QueryDocumentSnapshot]()
    var isFirstGetPhotos = true
    var newImageVIew : UIImage?
    @IBOutlet weak var foodImageViewAdd: UIImageView!
    var foodArrays = [String]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArrays.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddCollectionViewCell
        let photo = photos[indexPath.row]
        cell.foofLabel.text = photo.data()["Label"] as? String
//        if let timeStamp = photo.data()["date"] as? Timestamp {
//            let date =  Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//            formatter.timeStyle = .short
//            cell.dateLabel.text = formatter.string(from: date)
//        }
//        if let urlString = photo.data()["photoUrl"] as? String {
//            cell.photoImageView.kf.setImage(with: URL(string: urlString))
//            print(photo.data())
//        }
        return cell
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selece = info[.originalImage] as? UIImage
        foodImageViewAdd.image = selece
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func TapImageVIewAdd(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
        
        
    }
    
    
    @IBAction func addFoodArray(_ sender: Any) {
        
        if foodImageViewAdd != UIImage(named: "新增圖案"){
            upload()
            
        }
    }
    @IBOutlet weak var foodCollectionVIew: UICollectionView!
    override func viewDidLoad() {
        let db = Firestore.firestore()
        db.collection("CollectionView").order(by: "Label", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if self.isFirstGetPhotos {
                    self.isFirstGetPhotos = false
                    self.photos = querySnapshot.documents
                    self.foodCollectionVIew.reloadData()
                } else {
                    let documentChange = querySnapshot.documentChanges[0]
                    if documentChange.type == .modified, documentChange.document.data()["photoUrl"] != nil {
                        self.photos.insert(documentChange.document, at: 0)
                        self.foodCollectionVIew.insertItems(at: [IndexPath(row: 0, section: 0)])
                    }
                }
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func upload() {
        foodImageViewAdd.startAnimating()
        //  照片賦予生命
        let db = Firestore.firestore()
        let data: [String:Any] = ["Label" : foodName.text ?? ""]
        let photoReference : DocumentReference?
        //照片參照
        photoReference = db.collection("photo").addDocument(data: data){ (error) in
            guard error == nil  else {
                self.foodImageViewAdd.startAnimating()
                return
            }
        }
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(UUID().uuidString + ".jpg")
        let image = self.foodImageViewAdd.image
        if let data = image?.jpegData(compressionQuality: 0.8)
        { fileReference.putData(data,metadata: nil) {(metadate , error) in
            guard let _ = metadate, error == nil else {
                self.foodImageViewAdd.stopAnimating()
                return
            }
            fileReference.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    self.foodImageViewAdd.stopAnimating()
                    return
                }
                photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                self.navigationController?.popViewController(animated: true)
            }
                
            )}
            
            
        }
        
        
        
    }
    
    
}
