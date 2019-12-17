//
//  User.swift
//  Yeeter
//
//  Created by sam laitha on 11/13/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase.FIRDataSnapshot

class User:Identifiable {
    let uid: String
    //let email: String?
    let username: String?
    //var photoURL: URL?

//    init(uid: String, username: String?, email: String?) {
//        self.uid = uid
//        self.email = email
//        self.username = username
//    }
    
    init(uid: String, username: String?) {
        self.uid = uid
        self.username = username
        //self.photoURL = photoURL
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let dict = snapshot.value as? [String : AnyObject],
            let username = dict["username"] as? String
            //let photoURL = dict["photoURL"] as? URL
            //let email = dict["email"] as? String
            
        else { return nil }

        self.uid = snapshot.key
        self.username = username
        //self.photoURL = photoURL
        //self.email = email
    }
    
    func toAnyObject() -> Any {
        return [
            "username": username,
            //"email": email,
            "creationDate": String(describing: Date())
//            "photoURL": "https://firebasestorage.googleapis.com/v0/b/yeeter-backend.appspot.com/o/userdefault.png?alt=media&token=e032ae63-095c-4983-80ac-3e2e3a73a0c8"
        ]
    }

}
