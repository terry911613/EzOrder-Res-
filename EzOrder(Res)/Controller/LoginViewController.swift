//
//  LoginViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var paswordLabel: UILabel!
    var viewHeight: CGFloat?
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "goToEzOrder", sender: nil)
            }
        }
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        SVProgressHUD.show()
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "登入失敗", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.EmailLabel.isHidden = false
                self.EmailLabel.text = "帳號錯誤"
                self.EmailLabel.textColor = .red
                self.paswordLabel.text = "密碼錯誤"
                self.paswordLabel.textColor = .red
                self.paswordLabel.isHidden = false
            }
            else{
                self.EmailLabel.isEnabled = true
                self.paswordLabel.isEnabled = true
                print("Log in Successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToEzOrder", sender: self)
            }
        }
    }
    //  隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func unwindSegueBackLogin(segue: UIStoryboardSegue){
    }
}

extension LoginViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        viewHeight = view.frame.height
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let btnLocation = registerButton.superview?.convert(registerButton.frame.origin, to: view)
            print("location: ",btnLocation)
            let btnY = btnLocation!.y
            let btnHeight = registerButton.frame.height
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

