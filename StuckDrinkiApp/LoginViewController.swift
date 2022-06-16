//
//  LoginViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/13.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var btnPassword: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //更改成圓角
        btnPassword.layer.cornerRadius = 23
        //設定textField元件
        emailTextField.placeholder = "請輸入信箱"
        passwordTextField.placeholder = "請輸入密碼"
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    //點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //判斷登入
    @IBAction func loginActio(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //設定alert
            let alertCotroller = UIAlertController(title: "Error", message: "Please Enter Email and Passwors.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertCotroller.addAction(defaultAction)
            self.present(alertCotroller, animated: true,completion: nil)
        }else{
            //將資料從firebase後台抓取
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                //登入後透過在controller裡設定的ID跳轉
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                    self.present(vc!, animated: true,completion: nil)
                    
                }
                //錯誤alert
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true,completion: nil)
            }
            
            
            
            
            
        }
        
    }
    
    
}

    
    
