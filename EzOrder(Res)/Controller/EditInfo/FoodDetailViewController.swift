//
//  foodDetailssViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var foodCommentTableView: UITableView!
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    var commentArray = [QueryDocumentSnapshot]()
    
    var foodImage: String?
    var foodName: String?
    var foodPrice: Int?
    var foodDetail: String?
    var typeDocumentID: String?
    var foodDocumentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(foodDocumentID)
        print(typeDocumentID)
        
        if let foodImage = foodImage,
            let foodName = foodName,
            let foodPrice = foodPrice,
            let foodDetail = foodDetail,
            let typeDocumentID = typeDocumentID,
            let foodDocumentID = foodDocumentID,
            let resID = Auth.auth().currentUser?.email{
            
            foodImageView.kf.setImage(with: URL(string: foodImage))
            foodNameLabel.text = "菜名：\(foodName)"
            foodPriceLabel.text = "價格：$\(foodPrice)"
            foodDetailTextView.text = foodDetail
            
            let db = Firestore.firestore()
            print(foodDocumentID)
            db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).collection("foodComment").order(by: "date", descending: false).getDocuments { (comment, error) in
                
                if let comment = comment{
                    if comment.documents.isEmpty{
                        self.commentArray.removeAll()
                        self.foodCommentTableView.reloadData()
                    }
                    else{
                        self.commentArray = comment.documents
                        self.foodCommentTableView.reloadData()
                    }
                }
            }
            
            db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).getDocument { (rate, error) in
                if let rateData = rate?.data(){
                    if let foodTotalRate = rateData["foodTotalRate"] as? Float,
                        let foodRateCount = rateData["foodRateCount"] as? Float{
                        
                        if foodRateCount == 0{
                            self.rateImageView.isHidden = true
                        }
                        else{
                            self.updateStar(value: foodTotalRate/foodRateCount, image: self.rateImageView)
                        }
                    }
                }
            }
            
        }
    }
    func updateStar(value: Float, image: UIImageView) {
        let rate = value
        if rate < 2.75 {
            if rate < 0.25 {
                image.image = UIImage(named: "rate0")
            } else if rate < 0.75 {
                image.image = UIImage(named: "rate05")
            } else if rate < 1.25 {
                image.image = UIImage(named: "rate1")
            } else if rate < 1.75 {
                image.image = UIImage(named: "rate15")
            } else if rate < 2.25 {
                image.image = UIImage(named: "rate2")
            } else {
                image.image = UIImage(named: "rate25")
            }
        } else {
            if rate < 3.25 {
                image.image = UIImage(named: "rate3")
            } else if rate < 3.75 {
                image.image = UIImage(named: "rate35")
            } else if rate < 4.25 {
                image.image = UIImage(named: "rate4")
            } else if rate < 4.75 {
                image.image = UIImage(named: "rate45")
            } else {
                image.image = UIImage(named: "rate5")
            }
        }
    }
}

extension FoodDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCommentCell", for: indexPath) as! FoodDetailTableViewCell
        let comment = commentArray[indexPath.row]
        if let userID = comment.data()["userID"] as? String,
            let foodComment = comment.data()["foodComment"] as? String,
            let foodRate = comment.data()["foodRate"] as? Float{
            
            let db = Firestore.firestore()
            db.collection("user").document(userID).getDocument { (user, error) in
                if let userData = user?.data(){
                    if let userImage = userData["userImage"] as? String{
                        cell.userImageView.kf.setImage(with: URL(string: userImage))
                    }
                }
            }
            cell.commentTextView.text = foodComment
            updateStar(value: foodRate, image: cell.rateImageView)
        }
        return cell
    }
}
