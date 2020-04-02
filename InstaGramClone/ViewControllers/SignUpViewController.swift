//
//  SignUpViewController.swift
//  InstaGramClone
//
//  Created by Ashok Mishra on 29/03/20.
//  Copyright © 2020 Ashok Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.placeholder = "Username"
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes:[NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayer)
        
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.placeholder = "Email"
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.6)])
        
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(emailBottomLayer)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.placeholder = "Password"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        passwordBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
       passwordTextField.layer.addSublayer(passwordBottomLayer)
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        handleTextField()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func handleTextField(){
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)


    }
    
   @objc func textFieldDidChange(){
    guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
        signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        signUpButton.isEnabled = false
        return
    }
    
    signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
    signUpButton.isEnabled = true
    
    
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        
    }
    
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any){
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (User, Error) in
            if Error != nil{
                print(Error!.localizedDescription)
                return
            }
            let uid = User?.user.uid

            let storageRef = Storage.storage().reference(forURL: "gs://instagramclone-febad.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
                    
                    storageRef.downloadURL { (url:URL?, error:Error?) in
                        if let profileImageUrl = url?.absoluteString{
                            self.setUserInformation(profileImageUrl: profileImageUrl, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: uid!)
                            
                        }
                    }
                    
                    

                })
            }
            
        }
        
    }
    func setUserInformation(profileImageUrl:String, username:String, email:String, uid:String){
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        print(userReference.description())
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username": self.usernameTextField.text!, "email":self.emailTextField.text!, "profileImageUrl":profileImageUrl])
        self.performSegue(withIdentifier: "signUpTabbarVC", sender: nil)

    }
   
 
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            selectedImage = image
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
