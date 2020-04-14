//
//  HomeViewController.swift
//  InstaGramClone
//
//  Created by Ashok Mishra on 29/03/20.
//  Copyright © 2020 Ashok Mishra. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
//        if let currentuser = Auth.auth().currentUser?.description{
//            print("current user is \(currentuser)")
//        }else{
//            print("invalid")
//        }
        do{
           try Auth.auth().signOut()
        }catch{
            print("logouterror\(error)")
        }
//        if let currentuser = Auth.auth().currentUser?.description{
//                   print("current user is \(currentuser)")
//               }else{
//                   print("invalid")
//               }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signVC = storyboard.instantiateViewController(identifier: "SignInViewController")
        signVC.modalPresentationStyle = .fullScreen
        self.present(signVC, animated: true, completion: nil)
    }
    

}
