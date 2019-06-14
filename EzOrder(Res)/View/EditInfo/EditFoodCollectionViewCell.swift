//
//  muneCollectionViewCell.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//
import UIKit
import Firebase

class EditFoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodMoneyLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var statusSwich: UISwitch!
    @IBOutlet weak var menuView: UIView!
    
    var typeDocumentID: String?
    var foodName: String?
    
    @IBAction func statusAction(_ sender:UISwitch) {
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email,
            let foodType = typeDocumentID,
            let foodName = foodName{
            if sender.isOn {
                menuView.alpha = 1
                db.collection("res").document(resID).collection("foodType").document(foodType).collection("menu").document(foodName).updateData(["foodStatus": 1])
            }
            else {
                menuView.alpha = 0.2
                db.collection("res").document(resID).collection("foodType").document(foodType).collection("menu").document(foodName).updateData(["foodStatus": 0])
            }
        }
    }
}
