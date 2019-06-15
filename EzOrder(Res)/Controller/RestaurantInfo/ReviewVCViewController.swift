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
        searchShutDown()
        super.viewDidLoad()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchShutDown() {
        let db = Firestore.firestore()
        if let  resID = resID {
db.collection("res").document(resID).collection("storeconfirm").whereField("status", isEqualTo: 0)
            if let selfStatus = status?.data()["status"] as? Int {
               self.statusNumber = selfStatus
                if statusNumber == 0 {
                    shutDownStore.alpha = 1
                    ReviewLabel.text = "審核中"
                    ReMarksLabel.text = ""
                }
                
                
            }
        }
        
    }
    func searchReview(){
        let db = Firestore.firestore()
        if let resID = resID { db.collection("res").document(resID).collection("storeconfirm").whereField("status", isEqualTo: 2)
        }
        
    }
    func searchokStore() {
        let db = Firestore.firestore()
        if let resID = resID { db.collection("res").document(resID).collection("storeconfirm").whereField("status", isEqualTo: 1)
            
    
        }
        
    
    }
    
  

}
