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
import SVProgressHUD

class EditInfoViewController: UIViewController{
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    //    @IBOutlet weak var cellCollectionView: AddCollectionViewCell!
    @IBOutlet weak var resLogoImageView: UIImageView!
    //    @IBOutlet var longPressGest: UILongPressGestureRecognizer!
    @IBOutlet weak var resNameTextfield: UITextField!
    @IBOutlet weak var resTelTextfield: UITextField!
    @IBOutlet weak var resLocationTextfield: UITextField!
    @IBOutlet weak var resBookingLimitTextfield: UITextField!
    @IBOutlet weak var resTaxIDTextfield: UITextField!
    
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resTelLabel: UILabel!
    @IBOutlet weak var resLocationLabel: UILabel!
    @IBOutlet weak var resBookingLimitLabel: UILabel!
    @IBOutlet weak var resTaxIDLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var isEdit = false
    var resImage: String?
    var resName: String?
    var resTel: String?
    var resLocation: String?
    var resBookingLimit: Int?
    var resTaxID: String?
    var isEditImage: Bool?
    
    //    var p: CGPoint?
    //    var longPressed = false {
    //        didSet {
    //
    //            if oldValue != longPressed {
    //                foodCollectionVIew?.reloadData()
    //            }
    //
    //        }
    //    }
    var typeArray = [QueryDocumentSnapshot]()
    //    var isFirstGetPhotos = true
    //    var newImageVIew : UIImage?
    //    var foodArrays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let resID = resID{
            db.collection("res").document(resID).addSnapshotListener { (res, error) in
                if let resData = res?.data(){
                    if let resImage = resData["resImage"] as? String,
                        let resName = resData["resName"] as? String,
                        let resTel = resData["resTel"] as? String,
                        let resLocation = resData["resLocation"] as? String,
                        let resBookingLimit = resData["resBookingLimit"] as? Int,
                        let resTaxID = resData["resTaxID"] as? String{
                        
                        self.resImage = resImage
                        self.resName = resName
                        self.resTel = resTel
                        self.resLocation = resLocation
                        self.resBookingLimit = resBookingLimit
                        self.resTaxID = resTaxID
                        
                        self.isEdit = false
                        self.resLogoImageView.kf.setImage(with: URL(string: resImage))
                        self.resNameLabel.text = resName
                        self.resTelLabel.text = resTel
                        self.resLocationLabel.text = resLocation
                        self.resBookingLimitLabel.text = "\(resBookingLimit)"
                        self.resTaxIDLabel.text = resTaxID
                        
                        self.resNameTextfield.isHidden = true
                        self.resTelTextfield.isHidden = true
                        self.resLocationTextfield.isHidden = true
                        self.resBookingLimitTextfield.isHidden = true
                        self.resTaxIDTextfield.isHidden = true
                        self.resLogoImageView.isUserInteractionEnabled = false
                        self.editButton.isHidden = true
                    }
                    
                }
                else{
                    
                    self.isEdit = true
                    
                    self.resNameTextfield.isHidden = false
                    self.resTelTextfield.isHidden = false
                    self.resLocationTextfield.isHidden = false
                    self.resBookingLimitTextfield.isHidden = false
                    self.resTaxIDTextfield.isHidden = false
                    self.editButton.isHidden = false
                    self.resLogoImageView.isUserInteractionEnabled = true
                    
                    self.resNameLabel.isHidden = true
                    self.resTelLabel.isHidden = true
                    self.resLocationLabel.isHidden = true
                    self.resBookingLimitLabel.isHidden = true
                    self.resTaxIDLabel.isHidden = true
                    
                }
            }
        }
        
    }
    func getType(){
        if let resID = resID{
            db.collection("res").document(resID).collection("foodType").getDocuments { (type, error) in
                if let type = type{
                    self.typeArray = type.documents
                    self.typeCollectionView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getType()
    }
    
    // 判斷點選到哪個
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    //    }
    
    @IBAction func tapResLogoImageView(_ sender: UITapGestureRecognizer) {
        isEditImage = true
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
    }
    //    @IBAction func LongfoodInageViewAciton(_ sender: UILongPressGestureRecognizer) {
    //        if longPressed == true {
    //            switch (sender.state) {
    //            case .began:
    //                guard let select = foodCollectionVIew.indexPathForItem(at: sender.location(in:foodCollectionVIew))else{
    //                    print(1)
    //
    //                    break
    //                }
    //                foodCollectionVIew.beginInteractiveMovementForItem(at: select)
    //            case.changed:
    //                p = longPressGest.location(in: foodCollectionVIew)
    //                if let p = p, let indexPath = foodCollectionVIew?.indexPathForItem(at: p) {
    //                    print(5)
    //                    longPressed = true
    //
    //                    foodCollectionVIew.updateInteractiveMovementTargetPosition(sender.location(in: foodCollectionVIew!))
    //                }
    //            case.ended:
    //                foodCollectionVIew.endInteractiveMovement()
    //
    //            default:
    //                foodCollectionVIew.cancelInteractiveMovement()
    //
    //            }
    //        }
    //    }
    //
    //    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    //        p = gestureRecognizer.location(in: foodCollectionVIew)
    //        if let p = p, let _ = foodCollectionVIew?.indexPathForItem(at: p) {
    //            longPressed = true
    //        }
    //    }
    //
    //    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
    //        p = gestureRecognizer.location(in: foodCollectionVIew)
    //        if let p = p, foodCollectionVIew?.indexPathForItem(at: p) == nil {
    //            longPressed = false
    //        }
    //    }
    @IBAction func editInfoButton(_ sender: Any) {
        //        longPressed = !longPressed
        
        isEdit = !isEdit
        if isEdit{
            
            resNameTextfield.isHidden = false
            resTelTextfield.isHidden = false
            resLocationTextfield.isHidden = false
            resBookingLimitTextfield.isHidden = false
            resTaxIDTextfield.isHidden = false
            editButton.isHidden = false
            
            if let resName = resName,
                let resTel = resTel,
                let resLocation = resLocation,
                let resBookingLimit = resBookingLimit,
                let resTaxID = resTaxID{
                
                resNameTextfield.text = resName
                resTelTextfield.text = resTel
                resLocationTextfield.text = resLocation
                resBookingLimitTextfield.text = String(resBookingLimit)
                resTaxIDTextfield.text = resTaxID
            }
            
            resNameLabel.isHidden = true
            resTelLabel.isHidden = true
            resLocationLabel.isHidden = true
            resBookingLimitLabel.isHidden = true
            resTaxIDLabel.isHidden = true
            
            
            resLogoImageView.isUserInteractionEnabled = true
        }
        else{
            if let resImage = resLogoImageView.image,
                let resName = resNameTextfield.text, resName.isEmpty == false,
                let resTel = resTelTextfield.text, resTel.isEmpty == false,
                let resLocation = resLocationTextfield.text, resLocation.isEmpty == false,
                let resBookingLimit = Int(resBookingLimitTextfield.text!),
                let resTaxID = resTaxIDTextfield.text, resTaxID.isEmpty == false,
                let resID = resID{
                //DocumentReference 指定位置
                //照片參照
                SVProgressHUD.show()
                if let isEditImage = isEditImage{
                    if isEditImage{
                        let storageReference = Storage.storage().reference()
                        let fileReference = storageReference.child(UUID().uuidString + ".jpg")
                        let size = CGSize(width: 640, height: resImage.size.height * 640 / resImage.size.width)
                        UIGraphicsBeginImageContext(size)
                        resImage.draw(in: CGRect(origin: .zero, size: size))
                        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        if let data = resizeImage?.jpegData(compressionQuality: 0.8){
                            fileReference.putData(data,metadata: nil) {(metadate, error) in
                                guard let _ = metadate, error == nil else {
                                    SVProgressHUD.dismiss()
                                    self.errorAlert()
                                    return
                                }
                                fileReference.downloadURL(completion: { (url, error) in
                                    guard let downloadURL = url else {
                                        SVProgressHUD.dismiss()
                                        self.errorAlert()
                                        return
                                    }
                                    self.db.collection("res").document(resID).updateData(["resImage": downloadURL.absoluteString])
                                })
                            }
                        }
                    }
                }
                
                let data: [String: Any] = ["resName": resName,
                                           "resTel": resTel,
                                           "resLocation": resLocation,
                                           "resBookingLimit": resBookingLimit,
                                           "resTaxID": resTaxID]
                self.db.collection("res").document(resID).updateData(data, completion: { (error) in
                    guard error == nil else {
                        SVProgressHUD.dismiss()
                        self.errorAlert()
                        return
                    }
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "上傳完成", message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                })
                SVProgressHUD.dismiss()
            }
                
            else{
                let alert = UIAlertController(title: "請填寫完整", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
            
            resNameTextfield.isHidden = true
            resTelTextfield.isHidden = true
            resLocationTextfield.isHidden = true
            resBookingLimitTextfield.isHidden = true
            resTaxIDTextfield.isHidden = true
            editButton.isHidden = true
            
            resNameLabel.isHidden = false
            resTelLabel.isHidden = false
            resLocationLabel.isHidden = false
            resBookingLimitLabel.isHidden = false
            resTaxIDLabel.isHidden = false
            
            resLogoImageView.isUserInteractionEnabled = false
        }
        
    }
    
    func errorAlert(){
        let alert = UIAlertController(title: "上傳失敗", message: "請稍後再試一次", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EditInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainTypeCollectionViewCell
        let type = typeArray[indexPath.row]
        cell.typeLabel.text = type.data()["typeName"] as? String
        cell.typeImageView.kf.setImage(with: URL(string: type.data()["typeImage"] as! String))
        return cell
        //        let photo = typeArray[indexPath.row]
        //        cell.foofLabel.text = photo.data()["Label"] as? String
        //        if let urlString = photo.data()["photoUrl"] as? String {
        //            cell.foodImageView.kf.setImage(with: URL(string: urlString))
        //            if longPressed {
        //                let anim = CABasicAnimation(keyPath: "transform.rotation")
        //                anim.toValue = 0
        //                anim.fromValue = Double.pi/32
        //                anim.duration = 0.1
        //                anim.repeatCount = MAXFLOAT
        //                anim.autoreverses = true
        //                //            cell.layer.shouldRasterize = true
        //                cell.layer.add(anim, forKey: "SpringboardShake")
        //            }else {
        //
        //                cell.layer.removeAllAnimations()
        //            }
        //        }
        //        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = typeArray.remove(at: sourceIndexPath.item)
        typeArray.insert(item, at: destinationIndexPath.item)
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
