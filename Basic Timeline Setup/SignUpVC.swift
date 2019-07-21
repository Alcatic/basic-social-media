//
//  SignUpVC.swift
//  Basic Timeline Setup
//
//  Created by Di_Nerd on 7/21/19.
//  Copyright © 2019 Di_Nerd. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalPhoto.layer.cornerRadius = 16
        initalPhoto.layer.borderWidth = 1
        initalPhoto.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBOutlet weak var initalPhoto: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        
        guard let username = usernameTextField.text, !username.isEmpty else{return}
        print("username : \(username)")
        guard let email = emailTextField.text, !email.isEmpty else{return}
        guard let password = passwordTextField.text, !password.isEmpty else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
            
            if let error = error{
                print("Error occured")
                return
            }
            
            //Upload Image to Storage
            guard let image = self.initalPhoto.image else{fatalError("No image set so cannot upload to storage")}
            guard let imageData = image.jpegData(compressionQuality: 0.3) else{return}
            let uidString = UUID().uuidString
            
            //Storage
            let storageRef = Storage.storage().reference().child("profile_images").child(uidString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err{
                    print("error occured in storage completion \(err)")
                }
                
                //Get URL of image ...metadata.absoluteURL deprecated
                storageRef.downloadURL(completion: { (imageURL, err) in
                    
                    if let err = err{
                        print(err)
                    }
                    
                    guard let profileImageUrl = imageURL?.absoluteString else{return}
                    guard let uid = userData?.user.uid else{return}
                    let dictionaryValues = ["username": username, "profileImageUrl":profileImageUrl]
                    let values = [uid : dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err{
                            print("error occured \(err)")
                        }
                        
                        print("updated successfully!")
                    })
                    
                })
                
                print("uploaded image!!!")
            })
            
            //Add user info to Database
            
            
            
            
        }
    }
    
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            DispatchQueue.main.async {
              self.initalPhoto.image = editedImage
            }
            
        }else if let originalImage = info[.originalImage] as? UIImage{
            DispatchQueue.main.async {
                self.initalPhoto.image = originalImage
            }
            
        }
        dismiss(animated: true, completion: nil)
        
    }
}
