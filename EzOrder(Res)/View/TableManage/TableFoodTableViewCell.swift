//
//  TableFoodTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/9.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class TableFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodAmountLabel: UILabel!
    @IBOutlet weak var foodCompleteButton: UIButton!
    
    var orderNo: String?
    var foodName: String?
    var userID: String?
    var documentID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func foodCompleteButton(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email,
            let orderNo = orderNo,
            let userID = userID,
            let documentID = documentID{
            db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").document(documentID).getDocument { (food, error) in
                if let foodData = food?.data(){
                    if let orderFoodStatus = foodData["orderFoodStatus"] as? Int{
                        if orderFoodStatus == 0{
                            db.collection("user").document(userID).collection("order").document(orderNo).collection("orderFoodDetail").document(documentID).updateData(["orderFoodStatus": 1])
                            db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").document(documentID).updateData(["orderFoodStatus": 1])
                            self.foodCompleteButton.setImage(UIImage(named: "完成亮燈"), for: .normal)
                        }
                        else{
                            db.collection("user").document(userID).collection("order").document(orderNo).collection("orderFoodDetail").document(documentID).updateData(["orderFoodStatus": 0])
                            db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").document(documentID).updateData(["orderFoodStatus": 0])
                            self.foodCompleteButton.setImage(UIImage(named: "完成"), for: .normal)
                        }
                    }
                }
            }
        }
    }
    
}
