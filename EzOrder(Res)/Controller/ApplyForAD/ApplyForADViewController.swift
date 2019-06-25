//
//  ApplyForADViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ApplyForADViewController: UIViewController {
    
    @IBOutlet weak var startDatePickerButton: UIButton!
    @IBOutlet weak var endDatePickerButton: UIButton!
    @IBOutlet weak var ADImageView: UIImageView!
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func datePickerButton(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 a hh點mm分"
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.timeZone = TimeZone(identifier: "zh_TW")
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            let date = formatter.string(from: datePicker.date)
            if sender.tag == 0{
                self.startDatePickerButton.setTitle(date, for: .normal)
                self.startDate = datePicker.date
            }
            else{
                self.endDatePickerButton.setTitle(date, for: .normal)
                self.endDate = datePicker.date
            }
        }
        dateAlert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    @IBAction func chooseADImage(_ sender: Any) {
        let imagePickerContorller = UIImagePickerController()
        imagePickerContorller.sourceType = .photoLibrary
        imagePickerContorller.delegate = self
        present(imagePickerContorller,animated: true)
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        
        upload()
    }
    
    func upload(){
        let alert = UIAlertController(title: "確定送出廣告審核？", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
            
            if let resID = Auth.auth().currentUser?.email,
                let startDate = self.startDate,
                let endDate = self.endDate,
                let ADImage = self.ADImageView.image{
                
                let timeStamp = Date().timeIntervalSince1970
                let documentID = String(timeStamp) + resID
                let db = Firestore.firestore()
                
                SVProgressHUD.show()
                let storageReference = Storage.storage().reference()
                let fileReference = storageReference.child(UUID().uuidString + ".jpg")
                let size = CGSize(width: 640, height: ADImage.size.height * 640 / ADImage.size.width)
                UIGraphicsBeginImageContext(size)
                ADImage.draw(in: CGRect(origin: .zero, size: size))
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
                            let data: [String: Any] = ["documentID": documentID,
                                                       "resID": resID,
                                                       "ADImage": downloadURL.absoluteString,
                                                       "startDate": startDate,
                                                       "endDate": endDate,
                                                       "date": Date(),
                                                       "ADStatus": 0]
                            db.collection("manage").document("check").collection("AD").document(documentID).setData(data)
                            db.collection("res").document(resID).collection("AD").document(documentID).setData(data, completion: { (error) in
                                guard error == nil else {
                                    SVProgressHUD.dismiss()
                                    self.errorAlert()
                                    return
                                }
                                SVProgressHUD.dismiss()
                                
                                self.startDatePickerButton.setTitle("請選擇開始時間", for: .normal)
                                self.endDatePickerButton.setTitle("請選擇結束時間", for: .normal)
                                self.ADImageView.image = UIImage(named: "新增圖案")
                                self.startDate = nil
                                self.endDate = nil
                                
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
    
    func errorAlert(){
        let alert = UIAlertController(title: "上傳失敗", message: "請稍後再試一次", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
extension ApplyForADViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[.originalImage] as? UIImage {
            ADImageView.image = selectImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
