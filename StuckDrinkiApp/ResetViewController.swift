//
//  ResetViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/13.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定TextField元件
        emailTextField.placeholder = "請輸入信箱"
        emailTextField.delegate = self
    }
    //點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //重設
    @IBAction func restAction(_ sender: Any) {
        
        //判斷
        if self.emailTextField.text == "" {
            
            let alertController = UIAlertController(title: "Opps", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true,completion: nil)
            
        }else{
            //抓FireBase註冊好的信箱並傳送重設密碼網址
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!,completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Error"
                    //Firebase內建判斷格式
                    message = (error?.localizedDescription)!
                }else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                //按下OK之後做返回登入頁面的動作
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                    self.present(vc, animated: true,completion: nil)})
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
            
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
