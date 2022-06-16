//
//  RegisterViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/13.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定TextField元件
        emailTextField.placeholder = "請輸入信箱"
        passwordTextField.placeholder = "請輸入密碼"
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    //點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //註冊
    @IBAction func registerAction(_ sender: Any) {
        //註冊判定
        if emailTextField.text == ""{
            //設定alert
            let alert = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true,completion: nil)
            
        }else{
            //將註冊完的Firebase資料傳至後台並建立
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
                
                //註冊完直接進入選擇飲料類型
                if error == nil{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                    self.present(vc!, animated: true,completion: nil)
                    
                    
                }else{
                    //錯誤alert
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true,completion: nil)
                }
                
                
            }
        }
        
        
    }
    

}
