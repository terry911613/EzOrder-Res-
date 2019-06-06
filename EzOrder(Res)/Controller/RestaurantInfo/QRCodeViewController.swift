//
//  ORCodeViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var tableTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func generateButton(_ sender: UIButton) {
        
        if let table = Int(tableTextfield.text!){
            let text = String(table)
            let data = text.data(using: .utf8)
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            ciFilter.setValue(data, forKey: "inputMessage")
            guard let ciImage_smallQR = ciFilter.outputImage else { return }
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            let uiImage = UIImage(ciImage: ciImage_largeQR)
            imageView.image = uiImage
        }
        tableTextfield.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
