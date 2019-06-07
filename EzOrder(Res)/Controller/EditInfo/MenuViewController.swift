//
//  muneViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/5/30.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MenuViewController: UIViewController{
//    @IBOutlet weak var imageViews: UIImageView!
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet var menuCollection: [UICollectionView]!
    @IBOutlet weak var menuCollectionView: UICollectionView!
//    @IBOutlet weak var button: UIButton!
    @IBOutlet var optinss: [UIButton]!
    @IBOutlet var LongPress: UILongPressGestureRecognizer!
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    
    var uploadBool = false
    var editState = false
    var editInfoViewController : EditInfoViewController?
    var isFirstGetPhotos = true
    var p: CGPoint?
    var foodMoney = ""
    var foodName = ""
    var an = ""
    var typeArray = [QueryDocumentSnapshot]()
    var menuArray = [QueryDocumentSnapshot]()
    var longPressed = false {
        didSet {
            if oldValue != longPressed {
                menuCollectionView?.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let db = Firestore.firestore()
//        db.collection("photo").document(an).collection("Munes").addSnapshotListener{ (querySnapshot, error) in
//            if let querySnapshot = querySnapshot {
//                print("dd")
//                if self.isFirstGetPhotos {
//                    self.menuArray = querySnapshot.documents
//                    self.menuCollectionView.reloadData()
//                    print("add")
//                }else {
//                    print("UPd")
//                    let documentChange = querySnapshot.documentChanges[0]
//                    if documentChange.type == .modified, documentChange.document.data()["photoUrl"] != nil {
//                        self.menuArray.insert(documentChange.document, at: 0)
//                        self.menuCollectionView.reloadData()
//                        print(1)
//                    }
//                }
//            }
//            self.menuCollectionView.addGestureRecognizer(self.LOngPress)
//        }
        
        menuCollectionView.addGestureRecognizer(self.LongPress)
        for optinasss in menuCollection {
            UIView.animate(withDuration: 0.8, animations: {optinasss.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getType()
    }
    
    func getType(){
        if let resID = resID{
            db.collection(resID).document("food").collection("type").getDocuments { (type, error) in
                if let type = type{
                    self.typeArray = type.documents
                    self.typeCollectionView.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func stackAction(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.3, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func addMenu(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func menuEdit(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                self.editState = !self.editState
            })
        }
        longPressed = !longPressed
    }
    
    @IBAction func UPload(_ sender: Any) {
        //        let db = Firestore.firestore()
        //        db.collection("photo").document(an).collection("Munes").addSnapshotListener{ (querySnapshot, error) in
        //            if let querySnapshot = querySnapshot {
        //                print(1)
        //                   self.photos = querySnapshot.documents
        //                    self.muneCollectionView.reloadData()
        //                    print("add")
        //
        //            }
        //
        //
        //        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if editState  {
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goAdd" {
//            let  addMenuVC = segue.destination as! AddMenuViewController
//            addMenuVC.an = an
//        }
//        if segue.identifier == "editMunes" {
//            if let indexPath = muneCollectionView.indexPath(for: sender as! MenuCollectionViewCell){
//                let phot = photos[indexPath.row]
//                let mune = segue.destination as! editMuneViewController
//                mune.photos  = [phot]
//                let DocuntI = segue.destination as!
//                editMuneViewController
//                DocuntI.DID = phot.documentID
//                let  Docuntid = segue.destination as!
//                editMuneViewController
//                Docuntid.Dids = an
//            }
//        }
    }
    @IBAction func text222222(_ sender: UILongPressGestureRecognizer)
    {
        if longPressed == true {
            switch (sender.state) {
            case .began:
                guard let select = menuCollectionView.indexPathForItem(at: sender.location(in:menuCollectionView))else{
                    
                    break
                }
                menuCollectionView.beginInteractiveMovementForItem(at: select)
            case.changed:
                p = LongPress.location(in: menuCollectionView)
                if let p = p, let indexPath = menuCollectionView?.indexPathForItem(at: p) {
                    print(5)
                    longPressed = true
                    menuCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: menuCollectionView!))
                }
            case.ended:
                menuCollectionView.endInteractiveMovement()
                
            default:
                menuCollectionView.cancelInteractiveMovement()
                
            }
        }
    }
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        p = gestureRecognizer.location(in: menuCollectionView)
        if let p = p, let _ = menuCollectionView?.indexPathForItem(at: p) {
            longPressed = true
        }
    }
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        p = gestureRecognizer.location(in: menuCollectionView)
        if let p = p, menuCollectionView?.indexPathForItem(at: p) == nil {
            longPressed = false
        }
    }
    
}

extension MenuViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView{
            return typeArray.count
        }
        else{
            return menuArray.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! EditTypeCollectionViewCell
            let type = typeArray[indexPath.row]
            cell.typeLabel.text = type.data()["typeName"] as? String
            cell.typeImage.kf.setImage(with: URL(string: type.data()["typeImage"] as! String))
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! EditFoodCollectionViewCell
            let photo = menuArray[indexPath.row]
            cell.foodNameLabel.text = photo.data()["Name"] as? String
            cell.foodMoneyLabel.text = photo.data()["Money"] as? String
            if let urlString = photo.data()["photoUrl"] as? String {
                cell.foodImageView.kf.setImage(with: URL(string: urlString))
                if longPressed {
                    cell.editNameTextfield.isHidden = false
                    cell.editMoneyTextfield.isHidden = false
                    cell.statusSwich.isHidden = false
                    
                }else {
                    foodMoney = cell.editMoneyTextfield.text ?? ""
                    foodName = cell.editNameTextfield.text ?? ""
                    cell.layer.removeAllAnimations()
                    cell.statusSwich.isHidden = true
                    cell.editNameTextfield.isHidden = true
                    cell.editMoneyTextfield.isHidden = true
                    if cell.menuView.alpha < 0.5 {
                        cell.foodNameLabel.text = "一條龍"
                    }
                    
                }
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == typeCollectionView{
            
        }
        else{
            let item = menuArray.remove(at: sourceIndexPath.item)
            menuArray.insert(item, at: destinationIndexPath.item)
        }
    }
}






