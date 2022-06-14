//
//  LoginViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/13.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var btnPassword: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPassword.layer.cornerRadius = 23
        
    }
    
    
    @IBAction func loginActio(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            let alertCotroller = UIAlertController(title: "Error", message: "Please Enter Email and Passwors.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertCotroller.addAction(defaultAction)
            self.present(alertCotroller, animated: true,completion: nil)
        }else{
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                    self.present(vc!, animated: true,completion: nil)
                    
                    
                    
                }
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.present(alertController, animated: true,completion: nil)
            }
            
            
            
            
            
        }
        
    }
    
    
}

    
    
