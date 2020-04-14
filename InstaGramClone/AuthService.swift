//
//  AuthService.swift
//  InstaGramClone
//
//  Created by Ashok Mishra on 03/04/20.
//  Copyright © 2020 Ashok Mishra. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    
    static func signIn(email:String, password:String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage:String?) -> Void ){

        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(username: String, email:String, password:String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage:String?) -> Void ){

         Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                  if error != nil{
                    onError(error?.localizedDescription)
                      return
                  }
                  let uid = user?.user.uid

            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_ROOF).child("profile_image").child(uid!)
                  
                      storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                          if error != nil{
                              return
                          }
                          
                          storageRef.downloadURL { (url:URL?, error:Error?) in
                              if let profileImageUrl = url?.absoluteString{
                                  self.setUserInformation(profileImageUrl: profileImageUrl, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                                  
                              }
                          }
                          
                          

                      })
                  }
                  
              }
    
    
    
   static func setUserInformation(profileImageUrl:String, username:String, email:String, uid:String, onSuccess: @escaping () -> Void){
           let ref = Database.database().reference()
           let userReference = ref.child("users")
           print(userReference.description())
           let newUserReference = userReference.child(uid)
           newUserReference.setValue(["username": username, "email":email, "profileImageUrl":profileImageUrl])
           onSuccess()
    

       }
}
