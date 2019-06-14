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
    @IBOutlet weak var foodDetailTextView: UITextView!
    
    var commentArray = [QueryDocumentSnapshot]()
    
    var foodImage: String?
    var foodName: String?
    var foodPrice: Int?
    var foodDetail: String?
    var typeName: String?
    var typeDocumentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let foodImage = foodImage,
            let foodName = foodName,
            let foodPrice = foodPrice,
            let foodDetail = foodDetail,
            let typeName = typeName,
            let resID = Auth.auth().currentUser?.email{
            
            foodImageView.kf.setImage(with: URL(string: foodImage))
            foodNameLabel.text = foodName
            foodPriceLabel.text = "$\(foodPrice)"
            foodDetailTextView.text = foodDetail
            
            let db = Firestore.firestore()
            db.collection("res").document(resID).collection("foodType").document(typeName).collection("menu").document(foodName).collection("foodComment").order(by: "date", descending: false).getDocuments { (comment, error) in
                
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
            
        }
    }
}

extension FoodDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCommentCell", for: indexPath)
        let comment = commentArray[indexPath.row]
        if let userID = comment.data()["userID"] as? String,
            let foodComment = comment.data()["foodComment"] as? String{
            
            cell.textLabel?.text = foodComment
            cell.detailTextLabel?.text = userID
        }
        return cell
    }
}
