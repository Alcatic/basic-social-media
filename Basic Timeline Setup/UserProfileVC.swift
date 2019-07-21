//
//  UserProfileVC.swift
//  Basic Timeline Setup
//
//  Created by Di_Nerd on 7/21/19.
//  Copyright © 2019 Di_Nerd. All rights reserved.
//

import UIKit
import Firebase


class UserProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        userCollectionView.register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
      
    }
    
    var user: User?
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    fileprivate func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else{return}
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.userCollectionView.reloadData()
            
        }) { (err) in
            print("failed to fetch user \(err)")
            return
        }
    }
}


extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileCell", for: indexPath) as! UserProfileCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID", for: indexPath) as! UserHeader
        header.user = self.user
        

        return header
    }
    
}
