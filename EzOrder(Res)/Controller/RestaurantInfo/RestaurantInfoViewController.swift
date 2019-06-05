//
//  RestaurantInfoViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import FirebaseAuth

class RestaurantInfoViewController: UIViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantReservationPeopleLimitLabel: UILabel!
    @IBOutlet weak var restaurantTableView: UITableView!
    
    var restaurant = ["QRCode生成", "編輯店家資訊", "查看廣告審核", "申請關店"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
}
