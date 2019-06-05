//
//  ApplyForADViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class ApplyForADViewController: UIViewController {

    @IBOutlet weak var startDatePickerButton: UIButton!
    @IBOutlet weak var endDatePickerButton: UIButton!
    @IBOutlet weak var ADImageView: UIImageView!
    
    var startDate = ""
    var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func datePickerButton(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.datePickerMode = .dateAndTime
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
            }
            else{
                self.endDatePickerButton.setTitle(date, for: .normal)
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
        let alert = UIAlertController(title: "確定送出廣告審核？", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
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
