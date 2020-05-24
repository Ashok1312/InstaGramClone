//
//  CameraViewController.swift
//  InstaGramClone
//
//  Created by Ashok Mishra on 29/03/20.
//  Copyright © 2020 Ashok Mishra. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Camera"

        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost(){
        if selectedImage != nil{
            self.removeButton.isEnabled = true
            self.shareButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            self.removeButton.isEnabled = false
            self.shareButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Please wait", interaction: false)
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            let photoIdString = NSUUID().uuidString
             let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_ROOF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata:nil,completion:{(metadata, error) in
                if error != nil{
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL { (url:URL?, error:Error?) in
                    if let photoUrl = url?.absoluteString{
                        self.sendDataToDatabase(photoUrl: photoUrl)
                    }
                }
                
            })
        }else{
            ProgressHUD.showError("Image Can't load")
        }
    }
    
    @IBAction func remove_touchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
    
    
    
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let newPostId = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPostId!)
        newPostReference.setValue(["postUrl":photoUrl, "caption": captionTextView.text!], withCompletionBlock:{
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    func clean()  {
         self.captionTextView.text = ""
         self.photo.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
    }
    

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            selectedImage = image
            photo.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
