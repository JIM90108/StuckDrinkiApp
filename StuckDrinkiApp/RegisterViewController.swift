//
//  RegisterViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/13.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerAction(_ sender: Any) {
        
        if emailTextField.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            present(alert, animated: true,completion: nil)
            
        }else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
                
                if error == nil{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                    self.present(vc!, animated: true,completion: nil)
                    
                    
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true,completion: nil)
                }
                
                
            }
        }
        
        
    }
    

}
