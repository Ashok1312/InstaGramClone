//
//  SignInViewController.swift
//  InstaGramClone
//
//  Created by Ashok Mishra on 27/03/20.
//  Copyright © 2020 Ashok Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.placeholder = "Email"
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes:[NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(emailBottomLayer)
       
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = .white
        passwordTextField.placeholder = "Password"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        passwordBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(passwordBottomLayer)
        
        handleTextField()

        // Do any additional setup after loading the view.
    }
    
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(){
     guard  let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
         signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
         signInButton.isEnabled = false
         return
     }
        
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.isEnabled = true


    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print("cgjvmgjhkj.,hjghcjvmjh,jgkhvjcgvmbj,nkjhvjgc\(error!.localizedDescription)")
                return
            }
            self.performSegue(withIdentifier: "signInToTabbbarVC", sender: nil)
        }
    }
    
}
