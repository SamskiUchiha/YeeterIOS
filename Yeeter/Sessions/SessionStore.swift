//
//  SessionStore.swift
//  Yeeter
//
//  Created by sam laitha on 10/29/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//
import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

class SessionStore : ObservableObject {
    @Published var items: [Yeet] = []
    @Published var posts: [String:Yeet] = [:]
    
    @Published var gettingPostsTest1: [Yeet] = []
    //Added --------
    @Published var usernameCurrent: String = ""
    @Published var photoCurrentURL: String = ""
    
    //End --------
    @Published var postsLiked: [String: String]=[:]
    @Published var postsDisliked: [String: String]=[:]
    
    @Published var postsPracticed: [String: Any] = [:]
    
    @Published var userKey:String = ""
    
    @Published var isLoggedIn: Bool?
    @Published var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) }}
    @Published var handle: AuthStateDidChangeListenerHandle?
    @Published var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
//    let profileReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("profile")
//    let posts_by_user = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/posts")
    
    let posts_by_user = Database.database().reference(withPath: "posts_by_user")
    let post_xlists = Database.database().reference(withPath: "posts_xlists")

    let personal_likes = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_likes")
    let personal_dislikes = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_dislikes")
    
    var usernamesRef: DatabaseReference = Database.database().reference(withPath: "usernamesRef")
    
    private var username:String = ""
    
    let get_following = Database.database().reference(withPath: "get_following")
    let checkFollowingRef = Database.database().reference(withPath: "check_following")
    var get_username_by_userId: DatabaseReference = Database.database().reference(withPath: "get_username_by_userId")
    
    let users_xlists = Database.database().reference(withPath: "users_xlists")
    
    let user_followers = Database.database().reference(withPath: "user_followers")
    
    public func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid,
                    username: user.displayName
                    //email: user.email
                )
                self.isLoggedIn = true
            
                self.getPersonalPosts()
                self.getPersonalLikes()
                self.getPersonalDislikes()
                
                //Added --------
                self.getCurrentUser()
                self.getCurrentUserPhoto()
                self.getFollowingUsersPosts(completion: { (ans) in
                          if ans {
                              print("got All posts")
                          }
                      })
                //End ---------
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
                self.isLoggedIn = false
                //self.unbind()
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

     func signOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
        self.unbind()
    }

    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
// additional methods (sign up, sign in) will go here
    //Start new functions -----------------------------------
    func getCurrentUser(){
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return}
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with:  { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.usernameCurrent = value?["username"] as? String ?? ""
                print(self.usernameCurrent)
            }, withCancel: { (err) in
                print(err)
            })
        }
    }
    
    func getCurrentUserPhoto(){
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return}
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with:  { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.photoCurrentURL = value?["photoURL"] as? String ?? ""
                print(self.photoCurrentURL)
            }, withCancel: { (err) in
                print(err)
            })
        }
    }
  

   func getFollowingUsersPosts(completion: @escaping(Bool) -> Void) {
       self.get_following.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").observe( DataEventType.value) { (snapshot) in
           self.gettingPostsTest1 = []
           for child in snapshot.children.allObjects as! [DataSnapshot]  { // looping through users im following
               self.posts_by_user.child(child.key).observe(DataEventType.value) { (snapshot) in
                   //print("GOT SNAPSHOT OF THE POSTS FROM THE USER IM FOLLOWING")
                   
                   if snapshot.childrenCount > 0 {
                       for Post in snapshot.children.allObjects as! [DataSnapshot] {
                           let postObject = Post.value as? [String: AnyObject]
                           if(postObject?["yeet"]==nil) {continue}
                           let postText = postObject?["yeet"] as! String

                           var amountLikes = -1
                            if let amountLikes1=postObject?["likes"] as! Int? {
                                amountLikes = amountLikes1
                            } else {
                                print("erro unwrapping likes")
                                continue
                            }

                            var amountDislikes = -1
                            if let amountDislikes1=postObject?["dislikes"] as! Int? {
                                amountDislikes=amountDislikes1
                            } else {
                                print("erro unwrapping dislikes")
                                continue
                            }
                           
                           var username = "username"
                           if let username1=postObject?["username"] as! String? {
                               username = username1
                           } else {
                               print("Error getting username from post")
                               continue
                           }
                           
                           var userId = "userId"
                           if let userId1 = postObject?["userId"] as! String? {
                               userId = userId1
                           } else {
                               print("Error getting user ID from post")
                               continue
                           }

                           let post = Yeet(yeet:postText)
                           post.likes=amountLikes
                           post.dislikes=amountDislikes
                           post.ref=Post.ref
                           post.key=Post.key
                           post.id=Post.key
                           post.username=username
                           post.userId=userId
                           
                           // code below makes sure posts are added only once
                           if self.gettingPostsTest1.count == 0{
                               //print("first post added: " , post.yeet)
                               self.gettingPostsTest1.append(post)
                           }
                           var exists = false
                           for i in self.gettingPostsTest1 {
                               //print("hello")
                               if i.key == post.key {
                                   exists = true
                                   break
                               }
                           }
                           if !exists {
                              // print("adding post: ", post.yeet)
                               self.gettingPostsTest1.append(post)
                           }
                       }
                   }
               }
           }
       }
       completion(true)
   }
    
    func getPersonalPosts(){
        posts_by_user.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").observe(DataEventType.value) { (snapshot) in
            self.items.removeAll()
            
            if snapshot.childrenCount > 0 {
                //var counter = 0
                for Post in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let postObject = Post.value as? [String: AnyObject]
                    if(postObject?["yeet"]==nil) {continue}
                    let postText = postObject?["yeet"] as! String

                    var amountLikes = -1
                     if let amountLikes1=postObject?["likes"] as! Int? {
                         amountLikes = amountLikes1
                     } else {
                         print("erro unwrapping likes")
                         continue
                     }
                    
                     var amountDislikes = -1
                     if let amountDislikes1=postObject?["dislikes"] as! Int? {
                         amountDislikes=amountDislikes1
                     } else {
                         print("erro unwrapping dislikes")
                         continue
                     }
                    
                    var username = "username"
                    if let username1=postObject?["username"] as! String? {
                        username = username1
                    } else {
                        print("Error getting username from post")
                        continue
                    }
                    
                    var userId = "userId"
                    if let userId1 = postObject?["userId"] as! String? {
                        userId = userId1
                    } else {
                        print("Error getting user ID from post")
                        continue
                    }

                    let post = Yeet(yeet:postText)
                    // creating new yeet object, then adding it to list of yeets (self.items)
                    post.likes=amountLikes
                    post.dislikes=amountDislikes
                    post.ref=Post.ref
                    post.key=Post.key
                    post.id=Post.key
                    post.username=username
                    post.userId=userId
                    self.items.append(post)
                    
                }
            }
        }
    }
    
    func uploadPost(yeet: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return}
        guard let usernameCurrent = Auth.auth().currentUser?.displayName else { return}
        let postRef = self.posts_by_user.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").childByAutoId()
        print(postRef)
        postRef.child("/likes").setValue(0)
        postRef.child("/dislikes").setValue(0)
        postRef.child("/yeet").setValue(yeet)
        
        postRef.child("/username").setValue(usernameCurrent)
        postRef.child("/userId").setValue(uid)
        
        let like_reference = self.post_xlists.child(postRef.key!).child("/users_liked")
        like_reference.child("dummy id").setValue("dummyvalue")
        
        let dislike_reference = post_xlists.child(postRef.key!).child("users_disliked")
        dislike_reference.child("dummy id").setValue("dummyvalue")
    }
    
    func managePostCounters(userKey:String, key: String, command: String){
        self.posts_by_user.child("\(userKey)/\(key)").runTransactionBlock { (MutableData) -> TransactionResult in
            let likeValue = MutableData.childData(byAppendingPath: "/likes").value as? Int
            let dislikeValue = MutableData.childData(byAppendingPath: "/dislikes").value as? Int
            if command == "increase_likes" {
                MutableData.childData(byAppendingPath: "/likes").value = likeValue! + 1
            } else if command == "decrease_likes" {
                MutableData.childData(byAppendingPath: "/likes").value = likeValue! - 1
            } else if command == "increase_dislikes" {
                MutableData.childData(byAppendingPath: "/dislikes").value = dislikeValue! + 1
            } else if command == "decrease_dislikes" {
                MutableData.childData(byAppendingPath: "/dislikes").value = dislikeValue! - 1
            }
            return TransactionResult.success(withValue: MutableData)
        }
    }
    
    //====================================================================//
    //                          IMPORTANT                                 //
    //====================================================================//
//    2019-11-25 13:08:36.965779-0800 Yeeter[35632:4380117] *** Terminating
//    app due to uncaught exception 'InvalidPathValidation', reason: '(child:)
//    Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
    //====================================================================//
    func checkUser(username: String, completion: @escaping(Bool) -> Void) {
//        if username == ""{
//            completion(false)
//        }
        usernamesRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.childSnapshot(forPath: username).exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    
    // THIS CHECKS IF USER EXISTS BEFORE ADDING
    func followUser(username: String) {
        var searchedUserKey = ""
        usernamesRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.childSnapshot(forPath: username).exists() { // check username exists
                // get user key and add that shit
                searchedUserKey = snapshot.childSnapshot(forPath: username).value as! String
                // adding that shit:          my key                                      ->user im now
                let newFollowing = self.get_following.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/\(searchedUserKey)")
                newFollowing.setValue(username)// set username as value
                // adding this to a portion of the database to check to see if a user is a follower
                let newFollowing1 = self.checkFollowingRef.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/\(username)")
                newFollowing1.setValue(searchedUserKey)
                // need to add user to list of followers of user following
                let newFollower = self.user_followers.child(searchedUserKey).child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
                newFollower.setValue("dummyvalue")
            } else {
                print("Func followUser(username: String) in SessionStore.swift\n Username given does not exists. Error.")
            }
        }
    }
    func unfollowUser(username:String){ // when unfollowing, need to update two parts of database. following and check_following
        var searchedUserKey = ""
        usernamesRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.childSnapshot(forPath: username).exists() { // check username exists
                // get user key and add that shit
                searchedUserKey = snapshot.childSnapshot(forPath: username).value as! String
                // remove from following.
                self.get_following.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/\(searchedUserKey)").removeValue()
                // remove from check_following
                self.checkFollowingRef.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/\(username)").removeValue()
                // remove user from list of followers of the user unfollowing
                self.user_followers.child(searchedUserKey).child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").removeValue()
            } else {
                print("Func followUser(username: String) in SessionStore.swift\n Username given does not exists. Error.")
            }
        }
    }
    
    func isFollowingUser(username: String, completion: @escaping(Bool) -> Void) {
        checkFollowingRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.childSnapshot(forPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))/\(username)").exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func userLikeOrDislike(postKey:String, completion: @escaping(String) -> Void) {
        self.post_xlists.child(postKey).observe(DataEventType.value) { (snapshot) in
            if snapshot.childSnapshot(forPath: "/\("users_liked")/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").exists() {
                print("LIKED FOO")
                completion("liked")
            } else if snapshot.childSnapshot(forPath:"/\("users_disliked")/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").exists() {
                print("DISLIKED FOO")
                completion("disliked")
            } else {
                print("NEITHER FOO")
                completion("neither")
            }
        }
    }
    
    func getFollowersAmount(completion: @escaping(Int) -> Void) {
        self.user_followers.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").observe(DataEventType.value) { (snapshot) in
            print("follower amount: ",snapshot.childrenCount)
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func getUserLikesAmount(completion: @escaping(Int) -> Void) {
        self.users_xlists.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_likes").observe(DataEventType.value) { (snapshot) in
            print("likes amount: ",snapshot.childrenCount)
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func getUserDislikesAmount(completion: @escaping(Int) -> Void) {
        self.users_xlists.child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_dislikes").observe(DataEventType.value) { (snapshot) in
            print("likes amount: ",snapshot.childrenCount)
            completion(Int(snapshot.childrenCount))
        }
    }
    
    //START get yeets function----------------------------------------------
    
    
    func addUserToLikeList(postKey:String){
        self.post_xlists.child(postKey).child("/users_liked").child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").setValue("dummy value")
    }
    
    func removeUserToLikeList(postKey:String){
        self.post_xlists.child(postKey).child("/users_liked").child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").removeValue()
    }
    
    func addUserToDislikeList(postKey:String){
        self.post_xlists.child(postKey).child("/users_disliked").child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").setValue("dummy value")
    }
    
    func removeUserToDislikeList(postKey:String){
        self.post_xlists.child(postKey).child("/users_disliked").child("\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").removeValue()
    }
    
    func uploadLike(likedPost:String){
        let newPostRef = users_xlists.child("/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_likes").child("/\(likedPost)")
        newPostRef.setValue("dummyvalue")
    }
    
    func removeLike(keyFromPost: String){
        users_xlists.child("/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_likes").child("/\(keyFromPost)").removeValue()
    }
    
    
    func uploadDislike(dislikedPost: String){
        let newPostRef = users_xlists.child("/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_dislikes").child("/\(dislikedPost)")
        newPostRef.setValue("dummyvalue")
    }
    
    func updateDislikes(keyFromPost: String) {
        users_xlists.child("/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))").child("/user_dislikes").child("/\(keyFromPost)").removeValue()
    }
    
    func getPersonalLikes(){
        // Saving likes into String list
        personal_likes.observe(DataEventType.value) { (snapshot) in
            self.postsLiked = [:]
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot{
                    if let val = snapshot.value{
                        let key = snapshot.key
                        self.postsLiked[key]=val as? String
                    }
                }
            }
        }
    }
    
    func getPersonalDislikes() {
        // Saving likes into String list
        personal_dislikes.observe(DataEventType.value) { (snapshot) in
            self.postsDisliked = [:]
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot{
                    if let val = snapshot.value{
                        let key = snapshot.key
                        self.postsDisliked[key]=val as? String
                    }
                }
            }
        }
    }
}





//   func updateYeet(userKey:String,username:String, key: String, yeet: String, likes: Int, dislikes: Int){
//        //let update = ["yeet": yeet, "likes": likes, "dislikes": dislikes,"username":username,"userId":userKey] as [String : Any]
//        //let childUpdate = ["\(key)": update]
////        posts_by_user.child(userKey).updateChildValues(childUpdate)
//        self.posts_by_user.child("\(userKey)/\(key)").runTransactionBlock { (MutableData) -> TransactionResult in
//            var likeValue = MutableData.childData(byAppendingPath: "/likes").value as? Int
//            print("VALUE RECEIVED: ", MutableData)
//
//            //MutableData.setValue(likeValue!+1, forKey: "/likes")
//            MutableData.childData(byAppendingPath: "/likes").value = likeValue! + 1
//            return TransactionResult.success(withValue: MutableData)
//        }
//    }
