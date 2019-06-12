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
import MapKit
class EditInfoViewController: UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var resLogoImageView: UIImageView!
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
    @IBOutlet weak var myMap: MKMapView!
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var isEdit = false
    var resImage: String?
    var resName: String?
    var resTel: String?
    var resLocation: String?
    var resBookingLimit: Int?
    var resTaxID: String?
    var typeArray = [QueryDocumentSnapshot]()
    var locations:CLLocationManager!
    
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
                        self.locations = CLLocationManager()
                        self.locations.delegate = self
                        self.locations.requestWhenInUseAuthorization()
                        self.locations.startUpdatingLocation()
                        self.setMapRegion()
                        let text = "我很帥"
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(text) { (placemarks, error) in
                            if error == nil && placemarks != nil && placemarks!.count > 0 {
                                if let placemark = placemarks!.first {
                                    let location = placemark.location!
//                                    self.setMapCenter(center: location.coordinate)
//                                    self.setMapAnnotation(location)
                                }
                            } else {
                                let title = "收尋失敗"
                                let message = "目前網路連線不穩定"
                                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(ok)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        
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
    
    
    @IBAction func tapResLogoImageView(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
    }
    @IBAction func editInfoButton(_ sender: Any) {
        
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
                            let data: [String: Any] = ["resImage": downloadURL.absoluteString,
                                                       "resName": resName,
                                                       "resTel": resTel,
                                                       "resLocation": resLocation,
                                                       "resBookingLimit": resBookingLimit,
                                                       "resTaxID": resTaxID]
                            self.db.collection("res").document(resID).setData(data, completion: { (error) in
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
                        })
                    }
                }
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
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        var region = MKCoordinateRegion()
        region.span = span
        myMap.setRegion(region, animated: true)
        myMap.regionThatFits(region)
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
