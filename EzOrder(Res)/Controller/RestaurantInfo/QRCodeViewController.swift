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
    
    
    @IBAction func ImageFram(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.imageView.center = view.center
            let imageSize = CGSize(width: 250, height: 250)
            self.imageView.bounds.size = imageSize
        }
        else if sender.selectedSegmentIndex == 2{
            self.imageView.center = view.center
            let imageSize = CGSize(width: 150  , height: 150)
            self.imageView.bounds.size = imageSize

        } else if sender.selectedSegmentIndex == 0 {
            self.imageView.center = view.center
            let imageSize = CGSize(width: 343, height: 343)
            self.imageView.bounds.size = imageSize
        }
        
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

    
    @IBAction func PrintItem(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [shareImage!], applicationActivities: [])
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF, .postToFacebook, .postToWeibo, .postToFlickr, .postToTwitter]
        present(activityViewController,animated: true,completion: nil)
    }
    
    
    @IBAction func getImageItem(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size,true, 0)
       view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let getImageVIew = UIImageView(image: shareImage)
        view.addSubview(getImageVIew)
        UIImageWriteToSavedPhotosAlbum(shareImage!, nil, nil, nil)
        UIView.animate(withDuration: 0.7, animations: {
            getImageVIew.frame = CGRect(x: 0, y: self.view.bounds.height / 1.5, width: self.view.bounds.width / 3, height: self.view.bounds.height / 3)
            
        }, completion: {finished in
            
            UIView.animate(withDuration: 2,delay: 1, animations: {
                getImageVIew.alpha = 0
                
            }, completion:{finished in
                getImageVIew.removeFromSuperview()
            }
            )
            
        })

        
    }
}
