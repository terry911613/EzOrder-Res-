//
//  CloseViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class CloseViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    var viewHeight: CGFloat?
    let resID = Auth.auth().currentUser?.email
    var status : QueryDocumentSnapshot?
    var statusNumber : Int?
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButton(_ sender: UIButton) {
        if passwordTextfield.text != "000000" {
            let alearContorller = UIAlertController(title: "輸入錯誤", message: nil, preferredStyle: .alert)
            let alear = UIAlertAction(title: "確定", style: .default, handler: nil)
            alearContorller.addAction(alear)
            present(alearContorller,animated: true,completion: nil)
        }else{
        let okAlearContorller = UIAlertController(title: "是否確認送出", message: "送出後將無法返回", preferredStyle: .alert)
        let okalear = UIAlertAction(title: "確定", style: .default, handler: {(okalear) in
            let db = Firestore.firestore()
            if  let resID = self.resID {
                db.collection("res").document(resID).updateData(["status": 2])
                            }
            self.dismiss(animated: true, completion: nil)
            
        })
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            okAlearContorller.addAction(cancel)
            okAlearContorller.addAction(okalear)
            present(okAlearContorller,animated: true,completion: nil)
        
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension CloseViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        viewHeight = view.frame.height
        let alertViewHeight = self.alertView.frame.height
        let alertViewLeftBottomY = alertView.frame.origin.y + alertViewHeight
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            
            let overlap = alertViewLeftBottomY + keyboardRect.height - viewHeight!
            if overlap > -10 {
                view.frame.origin.y = -(overlap + 10)
            }
        } else {
            view.frame.origin.y = -view.frame.height / 5
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
