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
class muneViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var imageViews: UIImageView!
    
    @IBOutlet var muneCollection: [UICollectionView]!
    @IBOutlet weak var muneCollectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var optinss: [UIButton]!
    @IBOutlet var LOngPress: UILongPressGestureRecognizer!
    var uploadBool = false
    var editState = false
    var editInfoViewController : EditInfoViewController?
    var isFirstGetPhotos = true
    var p: CGPoint?
    var  foodMoney = ""
    var  foodName = ""
    var longPressed = false {
        didSet {
            
            if oldValue != longPressed {
                muneCollectionView?.reloadData()
            }
            
        }
    }
    var an = ""
    var photos = [QueryDocumentSnapshot]()
    override func viewDidLoad() {
        let db = Firestore.firestore()
        db.collection("photo").document(an).collection("Munes").addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if self.isFirstGetPhotos {
                    self.isFirstGetPhotos = false
                    self.photos = querySnapshot.documents
                    self.muneCollectionView.reloadData()
                }else {
                    let documentChange = querySnapshot.documentChanges[0]
                    if documentChange.type == .modified
                        ,documentChange.document.data()["photoUrl"] != nil
                    {
                        
                        self.photos.insert(documentChange.document, at: 0)
                        self.muneCollectionView.reloadData()
                        print(1)
                    }
                }
            }
            self.muneCollectionView.addGestureRecognizer(self.LOngPress)
            
        }
       
        super.viewDidLoad()
        for optinasss in muneCollection {
            
            UIView.animate(withDuration: 0.8, animations: {optinasss.isHidden = false
                self.view.layoutIfNeeded()
                
            })
            //            UIView.animate(withDuration: 2,delay: 0,
            //                           usingSpringWithDamping: 0.1,
            //                           initialSpringVelocity: 1.8, animations: {
            //                            optinasss.isHidden = false
            //            })
            
        }
        
        
        
        
    }
    
    @IBAction func stackAction(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.3, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                
            })
            
        }
        
    }
    
    @IBAction func addMune(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                
            })
            
        }
    }
    @IBAction func muneEdit(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                self.editState = !self.editState
                
            })
            
        }
        
        longPressed = !longPressed
        
    }
    
    @IBAction func UPload(_ sender: Any) {
        upda()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "muneCell", for: indexPath) as! muneCollectionViewCell
        let photo = photos[indexPath.row]
        cell.muneFoodName.text = photo.data()["Name"] as? String
        cell.muneFoodMoney.text = photo.data()["Money"] as? String
        if let urlString = photo.data()["photoUrl"] as? String {
        cell.muneFoodImageView.kf.setImage(with: URL(string: urlString))
            if longPressed {
                cell.editNameText.isHidden = false
                cell.editMoney.isHidden = false
                cell.statusSwich.isHidden = false
                
            }else {
                foodMoney = cell.editMoney.text ?? ""
                foodName = cell.editNameText.text ?? ""
                cell.layer.removeAllAnimations()
                cell.statusSwich.isHidden = true
                cell.editNameText.isHidden = true
                cell.editMoney.isHidden = true
                if cell.muneView.alpha < 0.5 {
                    cell.muneFoodName.text = "一條龍"
                
            }
            
        }
       
    }
         return cell
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if editState  {
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAdd" {
            let  DocumentID = segue.destination as! muneAddViewController
            DocumentID.an = an
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = photos.remove(at: sourceIndexPath.item)
        photos.insert(item, at: destinationIndexPath.item)
    }
    
    @IBAction func text222222(_ sender: UILongPressGestureRecognizer)
    {
        if longPressed == true {
            switch (sender.state) {
            case .began:
                guard let select = muneCollectionView.indexPathForItem(at: sender.location(in:muneCollectionView))else{
                    
                    break
                }
                muneCollectionView.beginInteractiveMovementForItem(at: select)
            case.changed:
                p = LOngPress.location(in: muneCollectionView)
                if let p = p, let indexPath = muneCollectionView?.indexPathForItem(at: p) {
                    print(5)
                    longPressed = true
                    muneCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: muneCollectionView!))
                }
            case.ended:
                muneCollectionView.endInteractiveMovement()
                
            default:
                muneCollectionView.cancelInteractiveMovement()
                
            }
        }
    }
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        p = gestureRecognizer.location(in: muneCollectionView)
        if let p = p, let _ = muneCollectionView?.indexPathForItem(at: p) {
            longPressed = true
        }
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        p = gestureRecognizer.location(in: muneCollectionView)
        if let p = p, muneCollectionView?.indexPathForItem(at: p) == nil {
            longPressed = false
        }
    }
    
    
    
    func upda()  {
        
                        imageViews.startAnimating()
                        let db = Firestore.firestore()
                        let dats: [String:Any] = ["Name" : foodName,"Money":foodMoney]
                        var photoReference : DocumentReference?
         db.collection("photo").document(an).collection("Munes")
            .document("tL5MFf03WwjFRGJzhpkY").updateData(dats){
                            (error) in
                            guard error == nil  else {
                                self.imageViews.startAnimating()
                                return
                            }
                            let storageReference = Storage.storage().reference()
                            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
                let image =  self.imageViews.image
                            let size = CGSize(width: 640, height:
                                (image?.size.height)! * 640 / (image?.size.width)!)
                            UIGraphicsBeginImageContext(size)
                            image?.draw(in: CGRect(origin: .zero, size: size))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            if let data = resizeImage?.jpegData(compressionQuality: 0.8)
                            { fileReference.putData(data,metadata: nil) {(metadate , error) in
                                guard let _ = metadate, error == nil else {
                                    self.imageViews.stopAnimating()
                                    return
                                }
                                fileReference.downloadURL(completion: { (url, error) in
                                    guard let downloadURL = url else {
                                        self.imageViews.stopAnimating()
                                        return
                                    }
                                    photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                                }
                                )}
                            }
                        }
        
        
        
        
    }
    
}








