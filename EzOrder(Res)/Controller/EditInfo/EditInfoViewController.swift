//
//  ViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class EditInfoViewController: UIViewController{
    
    @IBOutlet weak var foodCollectionVIew: UICollectionView!
//    @IBOutlet weak var cellCollectionView: AddCollectionViewCell!
    @IBOutlet weak var resLogoImageView: UIImageView!
    @IBOutlet var longPressGest: UILongPressGestureRecognizer!
    @IBOutlet weak var resNameLabel: UITextField!
    @IBOutlet weak var resTelLabel: UITextField!
    @IBOutlet weak var resLocationLabel: UITextField!
    @IBOutlet weak var resBookingLimitLabel: UITextField!
    @IBOutlet weak var taxIDLabel: UITextField!
    
    var p: CGPoint?
    var longPressed = false {
        didSet {
            
            if oldValue != longPressed {
                foodCollectionVIew?.reloadData()
            }
            
        }
    }
    var photos = [QueryDocumentSnapshot]()
    var isFirstGetPhotos = true
    var newImageVIew : UIImage?
    var foodArrays = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let db = Firestore.firestore()
//        db.collection("photo").addSnapshotListener{ (querySnapshot, error) in
//            if let querySnapshot = querySnapshot {
//                if self.isFirstGetPhotos {
//                    self.isFirstGetPhotos = false
//                    self.photos = querySnapshot.documents
//                    self.foodCollectionVIew.reloadData()
//                }else {
//                    //    self.photos = querySnapshot.documents
//                    let documentChange = querySnapshot.documentChanges[0]
//                    if documentChange.type == .modified
//                        ,documentChange.document.data()["photoUrl"] != nil{
//                        self.photos.insert(documentChange.document, at: 0)
//                        self.foodCollectionVIew.reloadData()
//                    }
//                }
//
//            }
//
//        }
        foodCollectionVIew.addGestureRecognizer(longPressGest)
    }
    // 判斷點選到哪個
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Mune" {
//            if let indexPath = foodCollectionVIew.indexPath(for: sender as! AddCollectionViewCell) {
//                let phot = photos[indexPath.row]
//                let mune = segue.destination as! MenuViewController
//                mune.photos = [phot]
//                let  DocumentID = segue.destination as! MenuViewController
//                DocumentID.an = phot.documentID
//                print(phot)
//                
//                
//            }
//        }
    }
    
    @IBAction func tapResLogoImageView(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
    }
    @IBAction func LongfoodInageViewAciton(_ sender: UILongPressGestureRecognizer) {
        if longPressed == true {
            switch (sender.state) {
            case .began:
                guard let select = foodCollectionVIew.indexPathForItem(at: sender.location(in:foodCollectionVIew))else{
                    print(1)
                    
                    break
                }
                foodCollectionVIew.beginInteractiveMovementForItem(at: select)
            case.changed:
                p = longPressGest.location(in: foodCollectionVIew)
                if let p = p, let indexPath = foodCollectionVIew?.indexPathForItem(at: p) {
                    print(5)
                    longPressed = true
                    
                    foodCollectionVIew.updateInteractiveMovementTargetPosition(sender.location(in: foodCollectionVIew!))
                    
                    
                }
            case.ended:
                foodCollectionVIew.endInteractiveMovement()
                
            default:
                foodCollectionVIew.cancelInteractiveMovement()
                
            }
        }
    }
    
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        p = gestureRecognizer.location(in: foodCollectionVIew)
        if let p = p, let _ = foodCollectionVIew?.indexPathForItem(at: p) {
            longPressed = true
        }
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        p = gestureRecognizer.location(in: foodCollectionVIew)
        if let p = p, foodCollectionVIew?.indexPathForItem(at: p) == nil {
            longPressed = false
        }
    }
    @IBAction func gerkmgekrglke(_ sender: Any) {
        longPressed = !longPressed
    }
}

extension EditInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddCollectionViewCell
        let photo = photos[indexPath.row]
        cell.foofLabel.text = photo.data()["Label"] as? String
        if let urlString = photo.data()["photoUrl"] as? String {
            cell.foodImageView.kf.setImage(with: URL(string: urlString))
            if longPressed {
                let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = 0
                anim.fromValue = Double.pi/32
                anim.duration = 0.1
                anim.repeatCount = MAXFLOAT
                anim.autoreverses = true
                //            cell.layer.shouldRasterize = true
                cell.layer.add(anim, forKey: "SpringboardShake")
            }else {
                
                cell.layer.removeAllAnimations()
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = photos.remove(at: sourceIndexPath.item)
        photos.insert(item, at: destinationIndexPath.item)
    }
}
extension EditInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let selsct = info[.originalImage] as? UIImage{
            resLogoImageView.image = selsct
        }
        self.dismiss(animated: true)
    }
}
