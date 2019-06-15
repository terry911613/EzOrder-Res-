//
//  TableFoodViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/9.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import ViewAnimator
import Kingfisher

class TableFoodViewController: UIViewController {
    
    @IBOutlet weak var tableFoodTableView: UITableView!
    var orderNo: String?
    var foodArray = [QueryDocumentSnapshot]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTableFood()
    }
    
    func getTableFood(){
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email,
            let orderNo = orderNo{
            db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").getDocuments { (food, erroe) in
                if let food = food{
                    if food.documents.isEmpty{
                        self.foodArray.removeAll()
                        self.tableFoodTableView.reloadData()
                    }
                    else{
                        self.foodArray = food.documents
                        self.animateTableFoodTableView()
                    }
                }
            }
        }
    }
    
    func animateTableFoodTableView(){
        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
        tableFoodTableView.reloadData()
        UIView.animate(views: tableFoodTableView.visibleCells, animations: animations, completion: nil)
    }
}

extension TableFoodViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableFoodCell", for: indexPath) as! TableFoodTableViewCell
        let food = foodArray[indexPath.row]
        if let foodName = food.data()["foodName"] as? String,
            let foodImage = food.data()["foodImage"] as? String,
            let foodAmount = food.data()["foodAmount"] as? Int,
            let userID = food.data()["userID"] as? String,
            let orderNo = orderNo,
            let foodDocumentID = food.data()["foodDocumentID"] as? String{
            
            cell.foodDocumentID = foodDocumentID
            cell.userID = userID
            cell.orderNo = orderNo
            cell.foodNameLabel.text = foodName
            cell.foodImageView.kf.setImage(with: URL(string: foodImage))
            cell.foodAmountLabel.text = "數量：\(foodAmount)"
            
            let db = Firestore.firestore()
            if let resID = Auth.auth().currentUser?.email{
                db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").document(foodName).addSnapshotListener { (foodStatus, error) in
                    if let foodStatusData = foodStatus?.data(),
                        let orderFoodStatus = foodStatusData["orderFoodStatus"] as? Int{
                        if orderFoodStatus == 0{
                            cell.foodCompleteButton.setImage(UIImage(named: "完成"), for: .normal)
                        }
                        else{
                            cell.foodCompleteButton.setImage(UIImage(named: "完成亮燈"), for: .normal)
                        }
                    }
                }
                
            }
        }
        
        return cell
    }
}
