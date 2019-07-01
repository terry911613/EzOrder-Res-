//
//  RegisterViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    var viewHeight: CGFloat?
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
        emailTextfield.text = ""
        passwordTextfield.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func registerButton(_ sender: UIButton) {
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                self.emailLabel.isHidden = false
                self.passwordLabel.isHidden  = false
                self.emailLabel.text = "請輸入正確格式"
                self.passwordLabel.text = "請輸入六到十二位數密碼"
                self.emailLabel.textColor = .red
                self.passwordLabel.textColor = .red
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "註冊失敗", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.emailLabel.isHidden = true
                self.passwordLabel.isHidden = true
                let db = Firestore.firestore()
                if let resID = Auth.auth().currentUser?.email{
                    db.collection("res").document(resID).setData(["resID": resID,
                                                                  "resTotalRate": 0,
                                                                  "resRateCount": 0])
                }
                //  success
                print("Registration Successful!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "registerToEzOrder", sender: self)
            }
        }
    }
    //  隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
extension RegisterViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        viewHeight = view.frame.height
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let btnLocation = registerBtn.frame.origin
            print("location: ",btnLocation)
            let btnY = btnLocation.y
            let btnHeight = registerBtn.frame.height
            let overlap = btnY + btnHeight + keyboardRect.height - viewHeight!
            
            if overlap > 0 {
                view.frame.origin.y =  -(overlap + 5)
            }
            
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
