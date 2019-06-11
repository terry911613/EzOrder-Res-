//
//  EditMenuViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/7.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ViewAnimator

class EditMenuViewController: UIViewController {
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet var foodCollections: [UICollectionView]!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet var optinss: [UIButton]!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    var editState = false
    var p: CGPoint?
    
    var isEditPressed = false {
        didSet {
            if oldValue != isEditPressed {
                foodCollectionView?.reloadData()
            }
        }
    }
    
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var typeArray = [QueryDocumentSnapshot]()
    var foodArray = [QueryDocumentSnapshot]()
    var typeIndex: Int?
    var foodIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foodCollectionView.addGestureRecognizer(self.longPress)
        for optinasss in foodCollections {
            UIView.animate(withDuration: 0.8, animations: {optinasss.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getType()
        if typeArray.isEmpty == false, let typeIndex = typeIndex{
            if let type = typeArray[typeIndex].data()["typeName"] as? String{
                print(type)
                getFood(typeName: type)
                print(22222)
            }
        }
    }
    
    func getType(){
        if let resID = resID{
            db.collection("res").document(resID).collection("foodType").order(by: "index", descending: false).addSnapshotListener { (type, error) in
                if let type = type{
                    if type.documentChanges.isEmpty{
                        self.typeArray.removeAll()
                        self.typeCollectionView.reloadData()
                    }
                    else{
                        let documentChange = type.documentChanges[0]
                        if documentChange.type == .added {
                            self.typeArray = type.documents
                            self.typeAnimateCollectionView()
                            print("getType")
                        }
                    }
                }
            }
        }
    }
    func getFood(typeName: String){
        print("-------------")
        print(typeName)
        if let resID = resID{
            db.collection("res").document(resID).collection("foodType").document(typeName).collection("menu").order(by: "foodIndex", descending: false).addSnapshotListener { (food, error) in
                if let food = food{
                    if food.documents.isEmpty{
                        self.foodArray.removeAll()
                        self.foodCollectionView.reloadData()
                    }
                    else{
                        let documentChange = food.documentChanges[0]
                        if documentChange.type == .added {
                            self.foodArray = food.documents
                            print(self.foodArray.count)
                            self.foodAnimateCollectionView()
                            print("getFood Success")
                            print("-------------")
                        }
                    }
                }
            }
        }
    }
    //  顯示特效
    func typeAnimateCollectionView(){
        typeCollectionView.reloadData()
        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        typeCollectionView.performBatchUpdates({
            UIView.animate(views: self.typeCollectionView.orderedVisibleCells,
                           animations: animations, completion: nil)
        }, completion: nil)
    }
    func foodAnimateCollectionView(){
        foodCollectionView.reloadData()
        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        foodCollectionView.performBatchUpdates({
            UIView.animate(views: self.foodCollectionView.orderedVisibleCells,
                           animations: animations, completion: nil)
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func stackAction(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.3, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func addType(_ sender: UIButton) {
        let typeVC = storyboard?.instantiateViewController(withIdentifier: "typeVC") as! TypeViewController
        typeVC.index = typeArray.count
        present(typeVC, animated: true, completion: nil)
        
//        for optina in optinss {
//            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
////                self.view.layoutIfNeeded()
//                let typeVC = self.storyboard?.instantiateViewController(withIdentifier: "typeVC") as! AddTypeViewController
//                self.navigationController?.pushViewController(typeVC, animated: true)
//                self.editState = !self.editState
//            })
//        }
    }
    
    @IBAction func addMenu(_ sender: Any) {
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuVC") as! FoodViewController
        if let typeIndex = typeIndex{
            menuVC.typeIndex = typeIndex
            menuVC.typeArray = typeArray
            menuVC.foodIndex = foodArray.count
            present(menuVC, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "請先選擇要新增菜色的分類", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
//        for optina in optinss {
//            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
////                self.view.layoutIfNeeded()
//                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! AddMenuViewController
//                self.navigationController?.pushViewController(menuVC, animated: true)
//                self.editState = !self.editState
//            })
//        }
    }
    
    @IBAction func editType(_ sender: UIButton) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                self.editState = !self.editState
            })
        }
        isEditPressed = !isEditPressed
//        for optina in optinss {
//            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
////                self.view.layoutIfNeeded()
//                let typeVC = self.storyboard?.instantiateViewController(withIdentifier: "typeVC") as! AddTypeViewController
//                self.navigationController?.pushViewController(typeVC, animated: true)
//                self.editState = !self.editState
//            })
//        }
    }
    
    @IBAction func editMenu(_ sender: Any) {
        for optina in optinss {
            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
                self.editState = !self.editState
            })
        }
        isEditPressed = !isEditPressed
//        for optina in optinss {
//            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
//                self.view.layoutIfNeeded()
////                self.editState = !self.editState
//                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! AddMenuViewController
//                self.navigationController?.pushViewController(menuVC, animated: true)
//                self.editState = !self.editState
//            })
//        }
//        longPressed = !longPressed
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if editState  {
//            return false
//        } else {
//            return true
//        }
//    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer){
        if isEditPressed == true {
            switch (sender.state) {
            case .began:
                guard let selectedIndexPath = foodCollectionView.indexPathForItem(at: sender.location(in:foodCollectionView))else{
                    break
                }
                foodCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case.changed:
//                p = LOngPress.location(in: menuCollectionView)
//                if let p = p, let indexPath = menuCollectionView?.indexPathForItem(at: p) {
//                    print(5)
                    isEditPressed = true
                    foodCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: foodCollectionView!))
//                }
            case.ended:
                foodCollectionView.endInteractiveMovement()
                
            default:
                foodCollectionView.cancelInteractiveMovement()
                
            }
        }
    }
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        p = gestureRecognizer.location(in: foodCollectionView)
        if let p = p, let _ = foodCollectionView?.indexPathForItem(at: p) {
            isEditPressed = true
        }
    }
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        p = gestureRecognizer.location(in: foodCollectionView)
        if let p = p, foodCollectionView?.indexPathForItem(at: p) == nil {
            isEditPressed = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodDetailSegue"{
            let foodDetailVC = segue.destination as! FoodDetailViewController
            if let foodIndex = foodIndex{
                let food = foodArray[foodIndex]
                if let foodName = food.data()["foodName"] as? String,
                    let foodImage = food.data()["foodImage"] as? String,
                    let foodPrice = food.data()["foodPrice"] as? Int,
                    let foodDetail = food.data()["foodDetail"] as? String{
                    
                    foodDetailVC.foodName = foodName
                    foodDetailVC.foodImage = foodImage
                    foodDetailVC.foodPrice = foodPrice
                    foodDetailVC.foodDetail = foodDetail
                }
            }
        }
    }

}

extension EditMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView{
            return typeArray.count
        }
        else{
            return foodArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! EditTypeCollectionViewCell
            
            let type = typeArray[indexPath.row]
            cell.typeLabel.text = type.data()["typeName"] as? String
            cell.typeImage.kf.setImage(with: URL(string: type.data()["typeImage"] as! String))
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! EditFoodCollectionViewCell
            
            let food = foodArray[indexPath.row]
            if let foodName = food.data()["foodName"] as? String,
                let foodImage = food.data()["foodImage"] as? String,
                let foodMoney = food.data()["foodPrice"] as? Int{
                
                cell.foodNameLabel.text = foodName
                cell.foodImageView.kf.setImage(with: URL(string: foodImage))
                cell.foodMoneyLabel.text = "$\(foodMoney)"
                
//                if isEditPressed {
//                    cell.editNameTextfield.isHidden = false
//                    cell.editMoneyTextfield.isHidden = false
//                    cell.statusSwich.isHidden = false
//                    
//                    cell.editNameTextfield.text = foodName
//                    cell.editMoneyTextfield.text = String(foodMoney)
//                }
//                else{
//                    cell.layer.removeAllAnimations()
//                    cell.statusSwich.isHidden = true
//                    cell.editNameTextfield.isHidden = true
//                    cell.editMoneyTextfield.isHidden = true
//                    if cell.menuView.alpha < 0.5 {
//                        cell.foodNameLabel.text = "一條龍"
//                    }
//                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
            cell.backView.backgroundColor = UIColor(red: 255/255, green: 66/255, blue: 150/255, alpha: 1)
//            print("didselect:\(indexPath.row)")
            typeIndex = indexPath.row
//            print("typeIndex: \(typeIndex)")
            if let type = typeArray[indexPath.row].data()["typeName"] as? String{
                getFood(typeName: type)
            }
        }
        else{
            foodIndex = indexPath.row
            performSegue(withIdentifier: "foodDetailSegue", sender: self)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
            cell.backView.backgroundColor = UIColor(red: 255/255, green: 162/255, blue: 195/255, alpha: 1)
//            print("diddeselect:\(indexPath.row)")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == typeCollectionView{
            
        }
        else{
            let item = foodArray.remove(at: sourceIndexPath.item)
            foodArray.insert(item, at: destinationIndexPath.item)
        }
    }
}




