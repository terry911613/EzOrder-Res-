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
    @IBOutlet var foodLongPress: UILongPressGestureRecognizer!
    @IBOutlet weak var guideLabel: UILabel!
    
    
    var isEndEdit = true
    var isMovePressed = false
    var isEditType = false
    var isEditFood = false
    let db = Firestore.firestore()
    let resID = Auth.auth().currentUser?.email
    var typeArray = [QueryDocumentSnapshot]()
    var foodArray = [QueryDocumentSnapshot]()
    var typeIndex: Int?
    var foodIndex: Int?
    var selectIndex: IndexPath?
    //    var prepare = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for optina in optinss {
//            optina.isHidden = true
//        }
        
        guideLabel.text = ""
        foodCollectionView.addGestureRecognizer(self.foodLongPress)
        typeCollectionView.addGestureRecognizer(self.longPress)
        
        for optinasss in foodCollections {
            UIView.animate(withDuration: 0.8, animations: {optinasss.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
        
        getType()
        if typeArray.isEmpty == false, let typeIndex = typeIndex{
            print(100)
            if let typeDocumentID = typeArray[typeIndex].data()["typeDocumentID"] as? String{
                print(1000)
                print("1",typeDocumentID)
                getFood(typeDocumentID: typeDocumentID)
                
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
                            //  print("getType")
                        }
                    }
                }
            }
        }
    }
    func getFood(typeDocumentID: String){
//        print("-------------")
           print(typeDocumentID)
        if let resID = resID{
            db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").order(by: "foodIndex", descending: false).addSnapshotListener { (food, error) in
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
    
    func reloadTwoCollectionView(){
        typeCollectionView.reloadData()
        foodCollectionView.reloadData()
    }
    func initStatus(){
        isMovePressed = false
        isEditType = false
        isEditFood = false
    }
    func initTypeImageAlpha(){
        if let selectIndex = selectIndex{
            let cell = typeCollectionView.cellForItem(at: selectIndex) as! EditTypeCollectionViewCell
            cell.typeImage.alpha = 0.2
        }
    }
    
    @IBAction func stackAction(_ sender: Any) {
        
//        stackView.isHidden = false
        
        for optina in optinss {
            UIView.animate(withDuration: 0.3, animations:{
                optina.isHidden = !optina.isHidden
                self.view.layoutIfNeeded()
            })
        }
        guideLabel.text = ""
        isEndEdit = !isEndEdit
        if isEndEdit{
            print(isEditType)
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations:{ self.typeCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.foodCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            initTypeImageAlpha()
            initStatus()
            reloadTwoCollectionView()
            print(isEditType)
            
        }
        else{
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations:{ self.typeCollectionView.transform = CGAffineTransform(translationX: 0, y: 80)
                self.foodCollectionView.transform = CGAffineTransform(translationX: 0, y: 80)
                
            }, completion: nil)
            print(isEditType)
//            stackView.isHidden = true
        }
    }
    
    @IBAction func addType(_ sender: UIButton) {
        
        let typeVC = storyboard?.instantiateViewController(withIdentifier: "typeVC") as! TypeViewController
        typeVC.index = typeArray.count
        present(typeVC, animated: true, completion: nil)
        guideLabel.text = ""
        
        initTypeImageAlpha()
//        typeCollectionView.reloadData()
        initStatus()
        typeCollectionView.reloadData()
//        initTypeImageAlpha()
//        reloadTwoCollectionView()
    }
    
    @IBAction func addMenu(_ sender: Any) {
        
//        initTypeImageAlpha()
        
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuVC") as! FoodViewController
        if let typeIndex = typeIndex{
            menuVC.typeIndex = typeIndex
            menuVC.typeArray = typeArray
            menuVC.foodIndex = foodArray.count
            present(menuVC, animated: true, completion: nil)
            guideLabel.text = ""
            initTypeImageAlpha()
            initStatus()
            typeCollectionView.reloadData()
        }
        else{
            let alert = UIAlertController(title: "請先選擇要新增菜色的分類", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func moveButton(_ sender: UIButton) {
        //        for optina in optinss {
        //            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
        //                self.view.layoutIfNeeded()
        ////                self.editState = !self.editState
        //            })
        //        }
//        initTypeImageAlpha()
        //        prepare = !prepare
        initTypeImageAlpha()
        isMovePressed = !isMovePressed
        isEditType = false
        isEditFood = false
        reloadTwoCollectionView()
        
        if isMovePressed{
            guideLabel.text = "請長按移動分類或食物到想要的順序"
        }
        else{
            guideLabel.text = ""
        }
//        initTypeImageAlpha()
    }
    
    @IBAction func editType(_ sender: UIButton) {
        //        for optina in optinss {
        //            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
        //                self.view.layoutIfNeeded()
        ////                self.editState = !self.editState
        //            })
        //        }
//        initTypeImageAlpha()
        initTypeImageAlpha()
        isEditType = !isEditType
        isMovePressed = false
        isEditFood = false
        reloadTwoCollectionView()
        
        if isEditType{
            guideLabel.text = "請點選想編輯的分類"
        }
        else{
            guideLabel.text = ""
        }
//        initTypeImageAlpha()
    }
    
    @IBAction func editFood(_ sender: UIButton) {
        //        for optina in optinss {
        //            UIView.animate(withDuration: 0.5, animations:{ optina.isHidden = !optina.isHidden
        //                self.view.layoutIfNeeded()
        ////                self.editState = !self.editState
        //            })
        //        }
        initTypeImageAlpha()
        
        isEditFood = !isEditFood
        isMovePressed = false
        isEditType = false
//        initTypeImageAlpha()
        reloadTwoCollectionView()
        
        if isEditFood{
            guideLabel.text = "請點選想編輯的食物"
        }
        else{
            guideLabel.text = ""
        }
//        initTypeImageAlpha()
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer){
        
        if isMovePressed == true {
            switch (sender.state) {
            case .began:
                guard let selectedIndexPath = typeCollectionView.indexPathForItem(at: sender.location(in:typeCollectionView))else{
                    break
                }
                typeCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case.changed:
                typeCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: typeCollectionView!))
                
            case.ended:
                typeCollectionView.endInteractiveMovement()
                
            default:
                typeCollectionView.cancelInteractiveMovement()
                
            }
        }
    }
    
    @IBAction func foodLongPresss(_ sender: UILongPressGestureRecognizer) {
        if isMovePressed == true {
            switch (sender.state) {
            case .began:
                guard let selectedIndexPath = foodCollectionView.indexPathForItem(at: sender.location(in:foodCollectionView))else{
                    break
                }
                foodCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case.changed:
                foodCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: foodCollectionView!))
                
            case.ended:
                foodCollectionView.endInteractiveMovement()
                
            default:
                foodCollectionView.cancelInteractiveMovement()
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodDetailSegue"{
            
            let foodDetailVC = segue.destination as! FoodDetailViewController
            if let foodIndex = foodIndex{
                let food = foodArray[foodIndex]
                print(food.data()["typeDocumentID"] as? String)
                print(food.data()["foodDocumentID"] as? String)
                if let foodName = food.data()["foodName"] as? String,
                    let foodImage = food.data()["foodImage"] as? String,
                    let foodPrice = food.data()["foodPrice"] as? Int,
                    let foodDetail = food.data()["foodDetail"] as? String,
                    let typeDocumentID = food.data()["typeDocumentID"] as? String,
                let foodDocumentID = food.data()["foodDocumentID"] as? String{
                    print("what the")
                    
                    foodDetailVC.foodName = foodName
                    foodDetailVC.foodImage = foodImage
                    foodDetailVC.foodPrice = foodPrice
                    foodDetailVC.foodDetail = foodDetail
                    foodDetailVC.typeDocumentID = typeDocumentID
                    foodDetailVC.foodDocumentID = foodDocumentID
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
            if isMovePressed {
                let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = 0
                anim.fromValue = Double.pi/32
                anim.duration = 0.1
                anim.repeatCount = MAXFLOAT
                anim.autoreverses = true
                cell.layer.add(anim, forKey: "SpringboardShake")
            }
            else {
                cell.layer.removeAllAnimations()
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! EditFoodCollectionViewCell
            
            let food = foodArray[indexPath.row]
            if let foodName = food.data()["foodName"] as? String,
                let foodImage = food.data()["foodImage"] as? String,
                let foodMoney = food.data()["foodPrice"] as? Int,
                let typeDocumentID = food.data()["typeDocumentID"] as? String,
                let foodDocumentID = food.data()["foodDocumentID"] as? String{
                
                cell.foodNameLabel.text = foodName
                cell.foodImageView.kf.setImage(with: URL(string: foodImage))
                cell.foodMoneyLabel.text = "$\(foodMoney)"
                cell.typeDocumentID = typeDocumentID
                cell.foodDocumentID = foodDocumentID
            }
            if let foodTotalRate = food.data()["foodTotalRate"] as? Float,
                let foodRateCount = food.data()["foodRateCount"] as? Float{
                let avgRate = foodTotalRate/foodRateCount
                
                if foodRateCount == 0{
                    cell.rateImageView.isHidden = true
                }
                else{
                    cell.rateImageView.isHidden = false
                    updateStar(value: avgRate, image: cell.rateImageView)
                }
            }
            
            if let foodStatus = food.data()["foodStatus"] as? Int{
                if foodStatus == 0{
                    cell.statusSwich.isOn = false
                }
                else{
                    cell.statusSwich.isOn = true
                }
            }
            
            if isEditFood{
                cell.statusSwich.isHidden = false
            }
            else{
                cell.statusSwich.isHidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == typeCollectionView{
            print("fuck")
            selectIndex = indexPath
            if isEditType{
                print(111)
                
                let cell = typeCollectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
                cell.typeImage.alpha = 1
                
                let typeVC = storyboard?.instantiateViewController(withIdentifier: "typeVC") as! TypeViewController
                let type = typeArray[indexPath.row]
                if let typeName = type.data()["typeName"] as? String,
                    let typeImage = type.data()["typeImage"] as? String{
                    typeVC.typeName = typeName
                    typeVC.typeImage = typeImage
                    present(typeVC, animated: true, completion: nil)
                }
            }
            else{
                print(222)
                let cell = typeCollectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
                cell.typeImage.alpha = 1
                typeIndex = indexPath.row
                print(typeArray[indexPath.row].data()["typeDocumentID"] as? String)
                if let typeDocumentID = typeArray[indexPath.row].data()["typeDocumentID"] as? String{
                    print(123)
                    getFood(typeDocumentID: typeDocumentID)
                }
            }
        }
        else{
            if isEditFood{
                let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuVC") as! FoodViewController
                let food = foodArray[indexPath.row]
                if let foodName = food.data()["foodName"] as? String,
                    let foodImage = food.data()["foodImage"] as? String,
                    let foodPrice = food.data()["foodPrice"] as? Int,
                    let foodDetail = food.data()["foodDetail"] as? String{
                    
                    menuVC.foodImage = foodImage
                    menuVC.foodName = foodName
                    menuVC.foodPrice = foodPrice
                    menuVC.foodDetail = foodDetail
                    present(menuVC, animated: true, completion: nil)
                }
            }
            else{
                foodIndex = indexPath.row
                if isMovePressed == false {
                    performSegue(withIdentifier: "foodDetailSegue", sender: self)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView{
            let cell = typeCollectionView.cellForItem(at: indexPath) as! EditTypeCollectionViewCell
            cell.typeImage.alpha = 0.2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == typeCollectionView{
            let item = typeArray.remove(at: sourceIndexPath.item)
            typeArray.insert(item, at: destinationIndexPath.item)
            
            let db = Firestore.firestore()
            if let resID = resID{
                for i in 0...typeArray.count - 1{
                    if let typeDocumentID = typeArray[i].data()["typeDocumentID"] as? String{
                        db.collection("res").document(resID).collection("foodType").document(typeDocumentID).updateData(["index": i])
                        db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").getDocuments { (food, error) in
                            if let food = food{
                                if food.documents.isEmpty == false{
                                    for food in food.documents{
                                        if let foodDocumentID = food.data()["foodDocumentID"] as? String{
                                            db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).updateData(["typeIndex": i])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else{
            let item = foodArray.remove(at: sourceIndexPath.item)
            foodArray.insert(item, at: destinationIndexPath.item)
            
            let db = Firestore.firestore()
            if let resID = resID{
                for i in 0...foodArray.count - 1{
                    if let foodDocumentID = foodArray[i].data()["foodDocumentID"] as? String,
                        let typeIndex = foodArray[i].data()["typeIndex"] as? Int,
                        let typeDocumentID = typeArray[typeIndex].data()["typeDocumentID"] as? String{
                        db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).updateData(["foodIndex": i])
                    }
                }
            }
        }
    }
}




