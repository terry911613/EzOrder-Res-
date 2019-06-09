//
//  RestaurantInfoViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher

class RestaurantInfoViewController: UIViewController {

    @IBOutlet weak var resTableView: UITableView!
    @IBOutlet weak var resImageView: UIImageView!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resTaxIDLabel: UILabel!
    
    var restaurant = ["QRCode生成", "查看廣告審核", "申請關店"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfo()
    }
    
    func getInfo(){
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email{
            db.collection("res").document(resID).getDocument { (res, error) in
                if let res = res{
                    if let resData = res.data(){
                        if let resImage = resData["resImage"] as? String,
                            let resName = resData["resName"] as? String,
                            let resTaxID = resData["resTaxID"] as? String{
                            
                            self.resImageView.kf.setImage(with: URL(string: resImage))
                            self.resNameLabel.text = resName
                            self.resTaxIDLabel.text = "統一編號：\(resTaxID)"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goLogin", sender: self)
        }
        catch{
            print("error, there was a problem logging out")
        }
    }
}

extension RestaurantInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        cell.textLabel?.text = restaurant[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let QRCodeVC = storyboard?.instantiateViewController(withIdentifier: "QRCodeVC") as! QRCodeViewController
            navigationController?.pushViewController(QRCodeVC, animated: true)
        }
        else if indexPath.row == 1{
            let checkADVC = storyboard?.instantiateViewController(withIdentifier: "checkADVC") as! CheckADViewController
            navigationController?.pushViewController(checkADVC, animated: true)
        }
        else if indexPath.row == 2{
            let closeVC = storyboard?.instantiateViewController(withIdentifier: "closeVC") as! CloseViewController
            present(closeVC, animated: true, completion: nil)
        }
    }
}
