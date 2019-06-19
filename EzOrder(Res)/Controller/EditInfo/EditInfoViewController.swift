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
    @IBOutlet weak var resTimeTextfield: UITextField!
    
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resTelLabel: UILabel!
    @IBOutlet weak var resLocationLabel: UILabel!
    @IBOutlet weak var resBookingLimitLabel: UILabel!
    @IBOutlet weak var resTaxIDLabel: UILabel!
    @IBOutlet weak var resTimeLabel: UILabel!
    //    @IBOutlet weak var resPeriodLabel: UILabel!
    
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var noonButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myMap: MKMapView!
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var isEdit = false
    var isEditImage = false
    var resImage: String?
    var resName: String?
    var resTel: String?
    var resLocation: String?
    var resBookingLimit: Int?
    var resTaxID: String?
    var resTime: String?
    var resPeriod: String?
    var status : QueryDocumentSnapshot?
    var statusNumber : Int?
    var typeArray = [QueryDocumentSnapshot]()
    var locations:CLLocationManager!
    var coordinates: CLLocationCoordinate2D?
    var isMorning = false
    var isNoon = false
    var isEvening = false
    
    
    override func viewDidLoad() {
        searchStoreconfirm()
        super.viewDidLoad()
        
        getType()
        
        if let resID = resID{
    db.collection("res").document(resID).addSnapshotListener { (res, error) in
                print("mother fucker")
                if let resData = res?.data(){
                    print("sucker")
                    if let resImage = resData["resImage"] as? String,
                        let resName = resData["resName"] as? String,
                        let resTel = resData["resTel"] as? String,
                        let resLocation = resData["resLocation"] as? String,
                        let resBookingLimit = resData["resBookingLimit"] as? Int,
                        let resTaxID = resData["resTaxID"] as? String,
                        let resTime = resData["resTime"] as? String,
                        let resPeriod = resData["resPeriod"] as? String{
                        
                        print("got it")
                        
                        self.resImage = resImage
                        self.resName = resName
                        self.resTel = resTel
                        self.resLocation = resLocation
                        self.resBookingLimit = resBookingLimit
                        self.resTaxID = resTaxID
                        self.resTime = resTime
                        
                        self.isEdit = false
                        self.resLogoImageView.kf.setImage(with: URL(string: resImage))
                        self.resNameLabel.text = resName
                        self.resTelLabel.text = resTel
                        self.resLocationLabel.text = resLocation
                        self.resBookingLimitLabel.text = "\(resBookingLimit)"
                        self.resTaxIDLabel.text = resTaxID
                        self.resTimeLabel.text = resTime
                        
                        self.morningButton.isEnabled = false
                        self.noonButton.isEnabled = false
                        self.eveningButton.isEnabled = false
                        
                        self.resPeriod = resPeriod
                        for i in resPeriod{
                            if i == "1"{
                                self.morningButton.backgroundColor = .white
                                self.morningButton.alpha = 1
                            }
                            else if i == "2"{
                                self.noonButton.alpha = 1
                                self.noonButton.backgroundColor = .white
                            }
                            else{
                                self.eveningButton.alpha = 1
                                self.eveningButton.backgroundColor = .white
                            }
                        }
                        
                        self.resNameTextfield.isHidden = true
                        self.resTelTextfield.isHidden = true
                        self.resLocationTextfield.isHidden = true
                        self.resBookingLimitTextfield.isHidden = true
                        self.resTaxIDTextfield.isHidden = true
                        self.resTimeTextfield.isHidden = true
                        self.resLogoImageView.isUserInteractionEnabled = false
                        self.editButton.isHidden = true
                        self.locations = CLLocationManager()
                        self.locations.delegate = self
                        self.locations.requestWhenInUseAuthorization()
                        self.locations.startUpdatingLocation()
                        self.setMapRegion()
                        let text = resLocation
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(text) { (placemarks, error) in
                            if error == nil && placemarks != nil && placemarks!.count > 0 {
                                if let placemark = placemarks!.first {
                                    let location = placemark.location!
                                    self.setMapCenter(center: location.coordinate)
                                    self.setMapAnnotation(location)
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
                    print("fuck it")
                    self.resNameTextfield.isHidden = false
                    self.resTelTextfield.isHidden = false
                    self.resLocationTextfield.isHidden = false
                    self.resBookingLimitTextfield.isHidden = false
                    self.resTaxIDTextfield.isHidden = false
                    self.resTimeTextfield.isHidden = false
                    self.editButton.isHidden = false
                    self.morningButton.isEnabled = true
                    self.noonButton.isEnabled = true
                    self.eveningButton.isEnabled = true
                    self.resLogoImageView.isUserInteractionEnabled = true
                    
                    self.resNameLabel.isHidden = true
                    self.resTelLabel.isHidden = true
                    self.resLocationLabel.isHidden = true
                    self.resBookingLimitLabel.isHidden = true
                    self.resTaxIDLabel.isHidden = true
                    self.resTimeLabel.isHidden = true
                    //                    self.resPeriodLabel.isHidden = true
                    
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
    
    @IBAction func periodButton(_ sender: UIButton) {
        if sender.tag == 0{
            isMorning = !isMorning
            if isMorning{
                morningButton.alpha = 1
            }
            else{
                morningButton.alpha = 0.5
            }
        }
        else if sender.tag == 1{
            isNoon = !isNoon
            if isNoon{
                noonButton.alpha = 1
            }
            else{
                noonButton.alpha = 0.5
            }
        }
        else{
            isEvening = !isEvening
            if isEvening{
                print(1)
                eveningButton.alpha = 1
            }
            else{
                eveningButton.alpha = 0.5
            }
        }
    }
    
    
    
    @IBAction func tapResLogoImageView(_ sender: UITapGestureRecognizer) {
        isEditImage = !isEditImage
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        searchStoreconfirm()
        if statusNumber == 0 {
            let alert = UIAlertController(title: "審核中", message: "可至個人頁面->店家審核,查看進度", preferredStyle: .alert)
          let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert,animated:true,completion: nil)
        }
        if statusNumber == 1 {
            let alert = UIAlertController(title: "審核成功", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
        else {
        upload()
        storeconfirm()
        }
    }
    func storeconfirm(){
        if let resID = resID{
           let data = ["status" : 0]
db.collection("res").document(resID).collection("storeconfirm").document("status").setData(data,completion:{
                (error) in
                guard error == nil else {
                    return
                }
            })
        }
    }
    
    func searchStoreconfirm(){
        if let resID = resID {
            db.collection("res").document(resID).collection("storeconfirm").document("status").addSnapshotListener{(store,error) in
                if let status = store?.data(){
                    self.statusNumber = status["status"] as? Int
                    
                }
            }
        }
    }
    
    
    @IBAction func editInfoButton(_ sender: Any) {
        
        isEdit = !isEdit
        if isEdit{
            resNameTextfield.isHidden = false
            resTelTextfield.isHidden = false
            resLocationTextfield.isHidden = false
            resBookingLimitTextfield.isHidden = false
            resTaxIDTextfield.isHidden = false
            resTimeTextfield.isHidden = false
            editButton.isHidden = false
            morningButton.isEnabled = true
            noonButton.isEnabled = true
            eveningButton.isEnabled = true
            
            if let resName = resName,
                let resTel = resTel,
                let resLocation = resLocation,
                let resBookingLimit = resBookingLimit,
                let resTaxID = resTaxID,
                let resTime = resTime,
                let resPeriod = resPeriod{
                
                resNameTextfield.text = resName
                resTelTextfield.text = resTel
                resLocationTextfield.text = resLocation
                resBookingLimitTextfield.text = String(resBookingLimit)
                resTaxIDTextfield.text = resTaxID
                resTimeTextfield.text = resTime
                
                for i in resPeriod{
                    if i == "1"{
                        isMorning = true
                    }
                    else if i == "2"{
                        isNoon = true
                    }
                    else{
                        isEvening = true
                    }
                }
            }
            
            resNameLabel.isHidden = true
            resTelLabel.isHidden = true
            resLocationLabel.isHidden = true
            resBookingLimitLabel.isHidden = true
            resTaxIDLabel.isHidden = true
            resTimeLabel.isHidden = true
            
            resLogoImageView.isUserInteractionEnabled = true
        }
        else{
            resNameTextfield.resignFirstResponder()
            resTelTextfield.resignFirstResponder()
            resLocationTextfield.resignFirstResponder()
            resBookingLimitTextfield.resignFirstResponder()
            resTaxIDTextfield.resignFirstResponder()
            resTimeTextfield.resignFirstResponder()
            if let resImage = resLogoImageView.image,
                let resName = resNameTextfield.text, resName.isEmpty == false,
                let resTel = resTelTextfield.text, resTel.isEmpty == false,
                let resLocation = resLocationTextfield.text, resLocation.isEmpty == false,
                let resBookingLimit = Int(resBookingLimitTextfield.text!),
                let resTaxID = resTaxIDTextfield.text, resTaxID.isEmpty == false,
                let resTime = resTimeTextfield.text, resTime.isEmpty == false,
                let resID = resID{
                //DocumentReference 指定位置
                //照片參照
                SVProgressHUD.show()
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
                                self.isEditImage = !self.isEditImage
                            })
                        }
                    }
                }
                
                var resPeriod = ""
                if isMorning{
                    resPeriod += "1"
                }
                if isNoon{
                    resPeriod += "2"
                }
                if isEvening{
                    resPeriod += "3"
                }
                
                let data: [String: Any] = ["resName": resName,
                                           "resTel": resTel,
                                           "resLocation": resLocation,
                                           "resBookingLimit": resBookingLimit,
                                           "resTaxID": resTaxID,
                                           "resTime": resTime,
                                           "resPeriod": resPeriod]
                self.db.collection("res").document(resID).updateData(data, completion: { (error) in
                    guard error == nil else {
                        SVProgressHUD.dismiss()
                        self.errorAlert()
                        return
                    }
                    SVProgressHUD.dismiss()
                })
                SVProgressHUD.dismiss()
                resNameTextfield.isHidden = true
                resTelTextfield.isHidden = true
                resLocationTextfield.isHidden = true
                resBookingLimitTextfield.isHidden = true
                resTaxIDTextfield.isHidden = true
                resTimeTextfield.isHidden = true
                editButton.isHidden = true
                morningButton.isEnabled = false
                noonButton.isEnabled = false
                eveningButton.isEnabled = false
                
                resNameLabel.isHidden = false
                resTelLabel.isHidden = false
                resLocationLabel.isHidden = false
                resBookingLimitLabel.isHidden = false
                resTaxIDLabel.isHidden = false
                resTimeLabel.isHidden = false
                //                resPeriodLabel.isHidden = false
                
                resLogoImageView.isUserInteractionEnabled = false
            }
            else{
                let alert = UIAlertController(title: "請填寫完整", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    func errorAlert(){
        let alert = UIAlertController(title: "上傳失敗", message: "請稍後再試一次", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    func setMapAnnotation(_ location: CLLocation) {
        if let text = resLocation {
            let coordinate = location.coordinate
            let annotation = MKPointAnnotation()
            self.coordinates = coordinate
            annotation.coordinate = coordinate
            annotation.title = text
            annotation.subtitle = "(\(coordinate.latitude), \(coordinate.longitude))"
            myMap.addAnnotation(annotation)
        }
        
        
    }
    func setMapCenter(center: CLLocationCoordinate2D) {
        myMap.setCenter(center, animated: true)
        
    }
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion()
        region.span = span
        myMap.setRegion(region, animated: true)
        myMap.regionThatFits(region)
    }
    func upload(){
        let alert = UIAlertController(title: "確定送出審核？", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            
            if let resID = self.resID,
                let resNameLabel = self.resNameLabel.text,
                let resTelLabel = self.resTelLabel.text,
                let resLogoImageView = self.resLogoImageView.image{
                print(1)
                let timeStamp = Date().timeIntervalSince1970
                let documentID = String(timeStamp) + resID
                SVProgressHUD.show()
                let storageReference = Storage.storage().reference()
                let fileReference = storageReference.child(UUID().uuidString + ".jpg")
                let size = CGSize(width: 640, height: resLogoImageView.size.height * 640 / resLogoImageView.size.width)
                UIGraphicsBeginImageContext(size)
                resLogoImageView.draw(in: CGRect(origin: .zero, size: size))
                let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let data = resizeImage?.jpegData(compressionQuality: 0.8){
                    fileReference.putData(data,metadata: nil) {(metadate, error) in
                        guard let _ = metadate, error == nil else {
                            SVProgressHUD.dismiss()
                            self.errorAlerts()
                            return
                        }
                        fileReference.downloadURL(completion: { (url, error) in
                            guard let downloadURL = url else {
                                SVProgressHUD.dismiss()
                                self.errorAlert()
                                return
                            }
                            let data: [String: Any] = ["resID": resID,
                                                       "resLogoImageView": downloadURL.absoluteString,
                                                       "resNameLabel": resNameLabel,
                                                       "date": Date(),
                                                       "resTelLabel": resTelLabel,
                                                       "status": 0]
                            self.db.collection("manage").document("check").collection("storeconfirm").document(documentID).setData(data, completion: { (error) in
                                guard error == nil else {
                                    SVProgressHUD.dismiss()
                                    self.errorAlert()
                                    return
                                }
                                SVProgressHUD.dismiss()
                                let alert = UIAlertController(title: "即將為您審核", message: nil, preferredStyle: .alert)
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
                self.present(alert, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func errorAlerts(){
        let alert = UIAlertController(title: "上傳失敗", message: "請稍後再試一次", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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

