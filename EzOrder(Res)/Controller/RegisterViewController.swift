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
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
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
                                                                  "resStatus": 0])
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
