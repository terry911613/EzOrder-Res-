//
//  OrderFoodDetailViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/16.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class OrderFoodDetailViewController: UIViewController {

    @IBOutlet weak var foodDetailTableView: UITableView!
    
    var orderFood = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension OrderFoodDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodDetailCell", for: indexPath) as! OrderFoodDetailTableViewCell
        
        let food = orderFood[indexPath.row]
        if let foodImage = food.data()["foodImage"] as? String,
            let foodName = food.data()["foodName"] as? String,
            let foodPrice = food.data()["foodPrice"] as? Int,
            let foodAmount = food.data()["foodAmount"] as? Int{
            
            cell.foodImageView.kf.setImage(with: URL(string: foodImage))
            cell.foodNameLabel.text = "菜名：\(foodName)"
            cell.foodPriceLabel.text = "價格：$\(foodPrice)"
            cell.foodAmountLabel.text = "數量：\(foodAmount)"
        }
        
        return cell
    }
    
    
}
