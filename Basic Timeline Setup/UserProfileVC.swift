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

        // Do any additional setup after loading the view.
    }
    
    

}


extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileCell", for: indexPath) as! UserProfileCell
        return cell
    }
    
    
    
}
