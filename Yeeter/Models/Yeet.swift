//
//  Yeet.swift
//  Yeeter
//
//  Created by Antonio Vega Jr on 10/25/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//
import Foundation
import SwiftUI
import FirebaseDatabase
//ObservableObject,
class Yeet: Identifiable {
    
    //@Published
    var ref: DatabaseReference?
    var id: String
    var yeet: String
    var key: String
    
    var usersLiked:[String:String]
    var usersDisliked:[String:String]
    
    var likes: Int
    var dislikes: Int
    
    var userLiked: Bool
    var userDisliked: Bool
    
    var username: String
    var userId: String

    
    init(yeet: String,key: String = "") {
        self.ref = nil
        self.yeet = yeet
        self.key = key
        self.id = key
        self.likes = 0
        self.dislikes = 0
        self.usersLiked=[:]
        self.usersDisliked=[:]
        self.userLiked=false
        self.userDisliked=false
        self.username = ""
        self.userId = ""
    }
    
//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let yeet = value["yeet"] as? String,
//            let likes = value["likes"] as? Int,
//            let dislikes = value["dislikes"] as? Int
//        else {
//            return nil
//        }
//        self.ref = snapshot.ref
//        self.key = snapshot.key
//        self.yeet = yeet
//        self.id = snapshot.key
//        self.likes = likes
//        self.dislikes = dislikes
//    }
    
    func toAnyObject() -> Any {
        return [
            "yeet": yeet,
            "likes": likes,
            "dislikes": dislikes,
        ]
    }
}

//
//  TODOS.swift
//  SwiftUIFirebase
//
//  Created by Mark Kinoshita on 10/29/19.
//  Copyright © 2019 Mark Kinoshita. All rights reserved.
//

//import Foundation
//import SwiftUI
//import FirebaseDatabase
//
//struct TODOS: Identifiable {
//
//    let ref: DatabaseReference?
//    let key: String
//    let todo: String
//    let isComplete: String
//    let id: String
//
//    init(todo: String, isComplete: String, key: String = "") {
//        self.ref = nil
//        self.key = key
//        self.todo = todo
//        self.isComplete = isComplete
//        self.id = key
//    }

//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let todo = value["todo"] as? String,
//            let isComplete = value["isComplete"] as? String
//            else {
//                return nil
//            }
//        self.ref = snapshot.ref
//        self.key = snapshot.key
//        self.todo = todo
//        self.isComplete = isComplete
//        self.id = snapshot.key
//    }
//
//    func toAnyObject() -> Any {
//        return [
//            "todo": todo,
//            "isComplete": isComplete,
//        ]
//    }
//}
//
