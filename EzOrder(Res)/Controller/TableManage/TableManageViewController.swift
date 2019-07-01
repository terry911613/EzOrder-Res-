//
//  TableManageViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import ViewAnimator

class TableManageViewController: UIViewController {
    
    @IBOutlet weak var tableStatusTableView: UITableView!
    
    var table = [String]()
    var allOrder = [QueryDocumentSnapshot]()
    var allServiceBell = [QueryDocumentSnapshot]()
    var selectOrderNo: String?
    var orderNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarItem.badgeValue = nil
        getOrder()
    }
    func getOrder(){
        let db = Firestore.firestore()
        let resID = Auth.auth().currentUser?.email
        if let resID = resID{
            db.collection("res").document(resID).collection("order").whereField("payStatus", isEqualTo: 0).addSnapshotListener { (order, error) in
                if let order = order{
                    if order.documents.isEmpty{
                        self.allOrder.removeAll()
                        self.tableStatusTableView.reloadData()
                    }
                    else{
                        self.tabBarItem.badgeValue = "New"
                        let documentChange = order.documentChanges[0]
                        if documentChange.type == .added{
                            self.allOrder = order.documents
                            self.tableStatusTableView.reloadData()
                        }
                    }
                }
                
            }
        } 
    }
    
    func animateTableStatusTableView(){
        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
        tableStatusTableView.reloadData()
        UIView.animate(views: tableStatusTableView.visibleCells, animations: animations, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableFoodSegue"{
            let tableFoodVC = segue.destination as! TableFoodViewController
            if let selectOrderNo = selectOrderNo{
                tableFoodVC.orderNo = selectOrderNo
            }
        }
    }
}

extension TableManageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableStatusCell", for: indexPath) as! TableManageTableViewCell
        
        let order = allOrder[indexPath.row]
        
        if let tableNo = order.data()["tableNo"] as? Int,
            let orderNo = order.data()["orderNo"] as? String,
            let userID = order.data()["userID"] as? String{
            cell.tableNoLabel.text = "\(tableNo)桌"
            cell.orderNo = orderNo
            cell.userID = userID
            
            let db = Firestore.firestore()
            if let resID = Auth.auth().currentUser?.email{
                db.collection("res").document(resID).collection("order").document(orderNo).collection("orderCompleteStatus").document("isOrderComplete").addSnapshotListener { (orderCompleteStatus, error) in
                    if let orderCompleteStatusData = orderCompleteStatus?.data(),
                        let orderCompleteStatus = orderCompleteStatusData["orderCompleteStatus"] as? Int{
                        if orderCompleteStatus == 0{
                            cell.completeImageView.image = UIImage(named: "完成")
                        }
                        else{
                            cell.completeImageView.image = UIImage(named: "完成亮燈")
                        }
                    }
                }
                db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").addSnapshotListener { (serviceBell, error) in
                    if let serviceBellData = serviceBell?.data(),
                        let serviceBellStatus = serviceBellData["serviceBellStatus"] as? Int{
                        if serviceBellStatus == 0{
                            print(serviceBellStatus)
                            cell.serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
                        }
                        else{
                            cell.serviceBellButton.setImage(UIImage(named: "服務鈴亮燈"), for: .normal)
                        }
                    }
                }
                db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").addSnapshotListener { (food, error) in
                    if let food = food,
                        food.documents.isEmpty == false{
                        //                        print("-------------")
                        //                        print(food.documents.count)
                        //                        print("-")
                        let documentChange = food.documentChanges[0]
                        if documentChange.type == .modified{
                            var count = 0
                            for food in food.documents{
                                //                                print(count)
                                //                                print("------")
                                //                                print(food.data()["orderFoodStatus"] as? Int)
                                
                                if let orderFoodStatus = food.data()["orderFoodStatus"] as? Int{
                                    if orderFoodStatus == 0{
                                        break
                                    }
                                    else{
                                        count += 1
                                    }
                                }
                            }
                            if count == food.documents.count{
                                db.collection("res").document(resID).collection("order").document(orderNo).collection("orderCompleteStatus").document("isOrderComplete").updateData(["orderCompleteStatus": 1])
                                db.collection("user").document(userID).collection("order").document(orderNo).collection("orderCompleteStatus").document("isOrderComplete").updateData(["orderCompleteStatus": 1])
                                print(12345)
                            }
                            else{
                                db.collection("res").document(resID).collection("order").document(orderNo).collection("orderCompleteStatus").document("isOrderComplete").updateData(["orderCompleteStatus": 0])
                                db.collection("user").document(userID).collection("order").document(orderNo).collection("orderCompleteStatus").document("isOrderComplete").updateData(["orderCompleteStatus": 0])
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = allOrder[indexPath.row]
        if let orderNo = order.data()["orderNo"] as? String{
            selectOrderNo = orderNo
            performSegue(withIdentifier: "tableFoodSegue", sender: self)
        }
    }
}
