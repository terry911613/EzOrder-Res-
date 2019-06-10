//
//  TableManageTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class TableManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableNoLabel: UILabel!
    @IBOutlet weak var serviceBellButton: UIButton!
    @IBOutlet weak var completeImageView: UIImageView!
    @IBOutlet weak var payImageView: UIImageView!
    
    var orderNo: String?
    var userID: String?
    
    //    var callBackService: ((_ clickService: Bool)->())?
    //    var isSeviceOn = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        if isSeviceOn == false{
        //            serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
        //        }
//        let db = Firestore.firestore()
//        if let orderNo = orderNo,
//            let resID = Auth.auth().currentUser?.email{
//            db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").addSnapshotListener { (serviceBell, error) in
//                if let serviceBellData = serviceBell?.data(),
//                    let serviceBellStatus = serviceBellData["serviceBellStatus"] as? Int{
//                    if serviceBellStatus == 0{
//                        self.serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
//                    }
//                    else{
//                        self.serviceBellButton.setImage(UIImage(named: "服務鈴亮燈"), for: .normal)
//                    }
//                }
//            }
//            
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func serviceBellButton(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email,
            let orderNo = orderNo,
            let userID = userID{
            db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").getDocument { (serviceBell, error) in
                if let serviceBellData = serviceBell?.data(){
                    if let serviceBellStatus = serviceBellData["serviceBellStatus"] as? Int{
                        if serviceBellStatus == 0{
                            db.collection("user").document(userID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").updateData(["serviceBellStatus": 1])
                            db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").updateData(["serviceBellStatus": 1])
                            self.serviceBellButton.setImage(UIImage(named: "服務鈴亮燈"), for: .normal)
                        }
                        else{
                            db.collection("user").document(userID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").updateData(["serviceBellStatus": 0])
                            db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").updateData(["serviceBellStatus": 0])
                            self.serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
                        }
                    }
                }
            }
        }
    }
}
