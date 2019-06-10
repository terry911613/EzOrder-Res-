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
                        self.allOrder = order.documents
                        self.animateTableStatusTableView()
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
                db.collection("res").document(resID).collection("order").document(orderNo).collection("serviceBellStatus").document("isServiceBell").addSnapshotListener { (serviceBell, error) in
                    if let serviceBellData = serviceBell?.data(),
                        let serviceBellStatus = serviceBellData["serviceBellStatus"] as? Int{
                        if serviceBellStatus == 0{
                            cell.serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
                        }
                        else{
                            cell.serviceBellButton.setImage(UIImage(named: "服務鈴亮燈"), for: .normal)
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
