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

    override func viewDidLoad() {
        let db = Firestore.firestore()
        db.collection("manage").document("check").collection("storeconfirm").whereField("status", isEqualTo: 1)
        
        super.viewDidLoad()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  

}
