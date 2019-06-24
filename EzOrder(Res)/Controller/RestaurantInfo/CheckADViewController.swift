//
//  CheckADViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ViewAnimator


class CheckADViewController: UIViewController {
    @IBOutlet weak var checkADTableView: UITableView!
    let resID = Auth.auth().currentUser?.email
    var ADArray =  [QueryDocumentSnapshot]()
    let format = DateFormatter()
    override func viewDidLoad() {
        
        let db = Firestore.firestore()
        if let resID = resID {
            db.collection("res").document(resID).collection("AD").order(by: "date", descending: true).getDocuments { (AD, error) in
                if let AD = AD{
                    if AD.documents.isEmpty{
                        self.ADArray.removeAll()
                        self.checkADTableView.reloadData()
                    }
                    else{
                        self.ADArray = AD.documents
                        self.animateTableView()
                    }
                }
            }
            format.locale = Locale(identifier: "zh_TW")
            format.dateFormat = "yyyy年MM月dd日 a hh:mm"
        }
    }
    func animateTableView(){
        let animations = [AnimationType.from(direction: .top, offset: 30.0)]
        checkADTableView.reloadData()
        UIView.animate(views: checkADTableView.visibleCells, animations: animations, completion: nil)
    }
}

extension CheckADViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ADArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkADCell", for: indexPath) as! CheckADTableViewCell
        let AD = ADArray[indexPath.row]
        if let resID = AD.data()["resID"] as? String,
            let timeStamp = AD.data()["date"] as? Timestamp,
            let imageView = AD.data()["ADImage"] as? String,
            let ADnumber = AD.data()["ADStatus"] as? Int{
            
            if ADnumber == 0 {
                cell.selectImageView.image = UIImage(named: "完成")
            }
            else if ADnumber == 1 {
                cell.selectImageView.image = UIImage(named: "完成亮燈")
            }
            else {
                cell.selectImageView.image = UIImage(named: "no")
            }
            cell.ADimageView.kf.setImage(with: URL(string: imageView))
            
            let db = Firestore.firestore()
            db.collection("res").document(resID).getDocument { (res, error) in
                if let resData = res?.data(){
                    if let resName = resData["resName"] as? String{
                        cell.adName.text = resName
                    }
                }
            }
            cell.adTime.text = self.format.string(from: timeStamp.dateValue())
        }
        return cell
    }
}
