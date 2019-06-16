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
    var statuss =  [QueryDocumentSnapshot]()
    let format = DateFormatter()
    override func viewDidLoad() {
        
        let db = Firestore.firestore()
        if let resID = resID { db.collection("res").document(resID).collection("AD").getDocuments { (AD, error) in
            if let AD = AD{
                if AD.documents.isEmpty{
                    self.statuss.removeAll()
                    self.checkADTableView.reloadData()
                }
                else{
                    self.statuss = AD.documents
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
                   return statuss.count
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkADCell", for: indexPath) as! CheckADTableViewCell
              let db = Firestore.firestore()
        db.collection("res").document(resID!).collection("AD").addSnapshotListener{(AD,error) in
            if let AD = AD {
                if AD.documents.isEmpty == false {
                    if let resID = AD.documents[indexPath.row].data()["resID"] as? String,
                        let timeStamp = AD.documents[indexPath.row].data()["date"] as? Timestamp,let imageView = AD.documents[indexPath.row].data()["ADImage"] as? String,let ADnumber  =  AD.documents[indexPath.row].data()["ADStatus"] as? Int{
                        if ADnumber == 1 {
                            cell.selectImageView.image = UIImage(named: "完成亮燈")
                        }
                        if ADnumber == 2 {
                            cell.selectImageView.image = UIImage(named: "no")
                            cell.ColerView.backgroundColor = .init(red: 238/255, green: 191/255, blue: 101/255, alpha: 1)

                                                    }
                        if ADnumber == 0 {   cell.selectImageView.image = UIImage(named: "完成")
                            cell.ColerView.backgroundColor = UIColor(red: 232/255, green: 160/255, blue: 229/255, alpha: 1)

                        }
                        
                        db.collection("res").document(resID).getDocument { (res, error) in
                            if let resData = res?.data(){
                                if let resName = resData["resName"] as? String{
                                    cell.adName.text = resName
                                    cell.ADimageView.kf.setImage(with: URL(string: imageView))
                                }
                            }
                        }
                        cell.adTime.text = self.format.string(from: timeStamp.dateValue())

                    }
                }
            }
            

        }
                return cell
    }
    
    
}
