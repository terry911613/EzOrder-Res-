//
//  orderRecordViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/11.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class OrderRecordViewController: UIViewController {

    @IBOutlet weak var orderRecordTableView: UITableView!
    
    let formatter = DateFormatter()
    let datePicker = UIDatePicker()
    
    var orderArray = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.locale = Locale(identifier: "zh_TW")
        self.formatter.dateFormat = "yyyy年M月d日"
        navigationItem.title = formatter.string(from: Date())
        getDatePicker()
        getOrder(date: formatter.string(from: Date()))
    }
    
    func getOrder(date: String){
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email{
            db.collection("res").document(resID).collection("order").whereField("dateString", isEqualTo: date).order(by: "date", descending: true).getDocuments(completion: { (order, error) in
                
                if let order = order{
                    if order.documents.isEmpty{
                        self.orderArray.removeAll()
                        self.orderRecordTableView.reloadData()
                    }
                    else{
                        self.orderArray = order.documents
                        self.orderRecordTableView.reloadData()
                    }
                }
            })
        }
    }
    @IBAction func clickDate(_ sender: UIBarButtonItem) {
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            
            self.formatter.dateFormat = "yyyy年M月d日"
            self.navigationItem.title = self.formatter.string(from: self.datePicker.date)
            self.getOrder(date: self.formatter.string(from: self.datePicker.date))
            
            print(self.datePicker.date)
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    func getDatePicker(){
        //  顯示 datePicker 方式和大小
        datePicker.locale = Locale(identifier: "zh_TW")
        formatter.dateStyle = .medium
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderFoodDetailVC = segue.destination as! OrderFoodDetailViewController
        if let indexPath = orderRecordTableView.indexPathForSelectedRow{
            let order = orderArray[indexPath.row]
            if let orderNo = order.data()["orderNo"] as? String{
                let db = Firestore.firestore()
                if let resID = Auth.auth().currentUser?.email{
                    db.collection("res").document(resID).collection("order").document(orderNo).collection("orderFoodDetail").getDocuments { (orderFood, error) in
                        if let orderFood = orderFood{
                            if orderFood.documents.isEmpty == false{
                                orderFoodDetailVC.orderFood = orderFood.documents
                                orderFoodDetailVC.foodDetailTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension OrderRecordViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderRecordCell", for: indexPath) as! OrderRecordTableViewCell
        
        let order = orderArray[indexPath.row]
        if let orderTimeStamp = order.data()["date"] as? Timestamp,
            let totalPrice = order.data()["totalPrice"] as? Int,
            let userID = order.data()["userID"] as? String{
            
            print("-------")
            print(orderTimeStamp.dateValue())
            print("-------")
            
            let db = Firestore.firestore()
            db.collection("user").document(userID).getDocument { (user, error) in
                if let userData = user?.data(){
                    if let userImage = userData["userImage"] as? String{
                        cell.userImageView.kf.setImage(with: URL(string: userImage))
                    }
                }
            }
            self.formatter.dateFormat = "yyyy年M月d日 a hh:mm"
            cell.dateLabel.text = formatter.string(from: orderTimeStamp.dateValue())
            cell.userIDLabel.text = "消費者：\(userID)"
            cell.totalPriceLabel.text = "總價：$\(totalPrice)"
        }
        
        if let usePoint = order.data()["usePoint"] as? Int{
            cell.pointLabel.isHidden = false
            cell.pointLabel.text = "折抵點數：\(usePoint)"
        }
        else{
            cell.pointLabel.isHidden = true
        }
        return cell
    }
}
