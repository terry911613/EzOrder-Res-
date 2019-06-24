//
//  ORCodeViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var tableTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let resID = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func generateButton(_ sender: UIButton) {
        
        if let table = Int(tableTextfield.text!){
            var qrCodeInfo = [String: String]()
            qrCodeInfo["resID"] = resID
            qrCodeInfo["table"] = String(table)
            let jsonData = try! JSONEncoder().encode(qrCodeInfo)
            
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            ciFilter.setValue(jsonData, forKey: "inputMessage")
            guard let ciImage_smallQR = ciFilter.outputImage else { return }
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            let uiImage = UIImage(ciImage: ciImage_largeQR)
            imageView.image = uiImage
            tableTextfield.resignFirstResponder()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
