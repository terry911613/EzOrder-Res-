//
//  ReviewVCViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/14.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
class ReviewVCViewController: UIViewController {
    
    @IBOutlet weak var shutDownStore: UIImageView!
    @IBOutlet weak var ReviewStore: UIImageView!
    @IBOutlet weak var okStore: UIImageView!
    @IBOutlet weak var ReviewLabel: UILabel!
    @IBOutlet weak var ReMarksLabel: UILabel!
    
    let resID = Auth.auth().currentUser?.email
    var status : QueryDocumentSnapshot?
    var statusNumber : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        if  let resID = resID  {
            print(resID)
            print(6)
            db.collection("res").document(resID).getDocument{(store,error) in
                if let status = store?.data(){
                    self.statusNumber = status["status"] as? Int
                    if  self.statusNumber == 0 {
                        self.ReviewLabel.text = "審核中"
                        self.ReMarksLabel.text = ""
                        self.shutDownStore.alpha = 1
                    }
                    else if self.statusNumber == 1 {
                        self.okStore.alpha = 1
                        self.ReviewLabel.text = "審核成功"
                        self.ReMarksLabel.text = ""
                    }
                    else if self.statusNumber == 2 {
                        self.ReviewStore.alpha = 1
                        self.ReviewLabel.text = "失敗"
                        self.ReMarksLabel.text = "餐廳資訊請填寫完整, 不可包含不雅圖片及字眼"
                    }
                }
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
