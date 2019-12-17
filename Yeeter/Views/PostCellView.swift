//
//  PostCellView.swift
//  Yeeter
//
//  Created by sam laitha on 11/24/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//

import SwiftUI

//struct FirebaseImage : View {
//    init(id: String) {
//        self.imageLoader = Loader(id)
//    }
//    @ObjectBinding private var imageLoader : Loader
//    var image: UIImage? {
//        imageLoader.data.flatMap(UIImage.init)
//    }
//    var body: some View {
//        Image(uiImage: image ?? placeholder)
//    }
//}

struct PostCellView: View {
    
    @ObservedObject var session: SessionStore
    @State var yeet: Yeet
    
    @State var thumbsdown="hand.thumbsdown"
    @State var thumbsup="hand.thumbsup"

    @State var likes = 0
    @State var dislikes = 0
    
    //@State var image : Image? = session.photoCurrentURL


    var body: some View {
        Group {
            VStack {
                        HStack {
                            
                            
             //               self.images(imageUrlString)
            //                   .resizable()
            //                   .frame(width: 50, height: 50)
            //                   .aspectRatio(contentMode: .fit)
            //                   .clipShape(Circle())
            //                   .shadow(radius: 10)
            //                    .aspectRatio(contentMode: .fit)
                            
                            Text("@\(yeet.username)")
                                .font(.system(size: 17.5))
                                .foregroundColor(.secondary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                                .padding(.leading, 5)
                                .padding(.bottom, 15)
                        }
                        VStack (){
                            HStack {
                                Text(yeet.yeet)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                                    .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .foregroundColor (.primary)
                                .padding(.top, 1)
                                .padding(.leading, 70)
                                .padding(.bottom, 5)
                                .padding(.trailing, 40)
                            }
                        }
                        VStack () {
                             HStack {
                                Image(systemName: self.thumbsup)
                                    .gesture(TapGesture()
                                        .onEnded {
                                            if self.thumbsdown == "hand.thumbsdown.fill"{
                                                return
                                            } else if self.thumbsup=="hand.thumbsup"{
                                                self.thumbsup="hand.thumbsup.fill"
                    
                                            } else {
                                                self.thumbsup="hand.thumbsup"
                    
                                            }
                                            self.likeButtonPressed()
                                        })
                                //Text("-")
                                Text(" \(self.likes)")
                                .padding(.trailing, 8)
                    
                                Image(systemName: self.thumbsdown)
                                    .gesture(TapGesture()
                                        .onEnded {
                                            if self.thumbsup == "hand.thumbsup.fill"{
                                                return
                                            }
                                            if self.thumbsdown=="hand.thumbsdown"{
                                                self.thumbsdown="hand.thumbsdown.fill"
                                            } else {
                                                self.thumbsdown="hand.thumbsdown"
                                            }
                                            self.dislikeButtonPressed()
                                        })
                                //Text("-")
                                Text(" \(self.dislikes)")
                        
                                   
                    
                            }// End of Hstack
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottomTrailing)
                            .padding(.top, 8)
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                           
                            //.padding(.leading, 200)
                       }
                        
                    }.onAppear(perform: setupLikeDislike)
        }
        .padding()
        .background( Color(.white))
        .clipped()
        //.shadow(radius: 5.0)
        //.cornerRadius(3)
            .shadow(color: Color(.gray), radius: 3, x: 1, y: 1)
        
    }
   
    func setupLikeDislike(){
        self.likes = yeet.likes
        self.dislikes = yeet.dislikes
        
        // setup thumbs by checking if user is within list of likes or dislikes
        
        
        self.session.userLikeOrDislike(postKey: self.yeet.key, completion: { (ans) in
            if ans == "liked" {
                //print("USER LIKED !!!!!")
                 self.thumbsup = "hand.thumbsup.fill"
                 self.thumbsdown = "hand.thumbsdown"
             } else if ans == "disliked" {
                //print("USER DISLIKED !!!!!")
                 self.thumbsdown = "hand.thumbsdown.fill"
                 self.thumbsup = "hand.thumbsup"
             } else {
                 //print("USER NEITHER !!!!!")
                 self.thumbsdown = "hand.thumbsdown"
                 self.thumbsup = "hand.thumbsup"
             }
        })
        
    }
    
    
//    func likeButtonPressed(){
//        if self.thumbsup == "hand.thumbsup.fill"{
//            print("LIKE")
//            self.likes+=1
//            self.session.uploadLike(likedPost:yeet.key) // adding like into list of likes
//            //self.yeet.usersLiked[self.session.userKey]="dummyvalue" // adding to list of users who liked
//
//            self.session.addUserToLikeList(postKey: self.yeet.key)
//            self.session.updateYeet(userKey:self.session.userKey, key: yeet.key, yeet: yeet.yeet, likes: self.likes, dislikes: self.dislikes)
//        } else { //undo like
//            print("UNDO LIKE")
//            self.likes-=1
//            self.session.removeLike(keyFromPost:yeet.key) // taking like out of list of likes
//            //self.yeet.usersLiked.removeValue(forKey: self.session.userKey) // removing user from users who have liked this post
//
//            self.session.removeUserToLikeList(postKey: self.yeet.key)
//            self.session.updateYeet(userKey:self.session.userKey, key: yeet.key, yeet: yeet.yeet, likes: self.likes, dislikes: self.dislikes)
//        }
//
//    }
//
//    func dislikeButtonPressed(){
//        if self.thumbsdown == "hand.thumbsdown.fill"{ //disliked yeet
//            print("DISLIKE")
//            self.dislikes+=1
//            self.session.uploadDislike(dislikedPost: yeet.key)
//            //self.yeet.usersDisliked[self.session.userKey]="dummyvalue" // adding user to users who have liked this post
//
//            self.session.addUserToDislikeList(postKey: self.yeet.key)
//            self.session.updateYeet(userKey:self.session.userKey, key: yeet.key, yeet: yeet.yeet, likes: self.likes, dislikes: self.dislikes)
//        } else { //undo dislike
//            print("UNDO DISLIKE")
//            self.dislikes-=1
//            self.session.updateDislikes(keyFromPost: yeet.key)
//            //self.yeet.usersDisliked.removeValue(forKey: self.session.userKey)// removing user from list of users who have disliked post
//
//            self.session.removeUserToDislikeList(postKey: yeet.key)
//            self.session.updateYeet(userKey:self.session.userKey,key: yeet.key, yeet: yeet.yeet, likes: self.likes, dislikes: self.dislikes)
//        }
//
//    }
    
    func likeButtonPressed(){
        if self.thumbsup == "hand.thumbsup.fill"{
            print("LIKE")
            self.likes+=1
            self.yeet.likes+=1
            self.session.uploadLike(likedPost:yeet.key) // adding like into list of likes
            
            self.session.addUserToLikeList(postKey: self.yeet.key)// adding userkey to list of likes in this post
            self.session.managePostCounters(userKey: self.yeet.userId, key: yeet.key, command: "increase_likes")
        } else { //undo like
            print("UNDO LIKE")
            self.likes-=1
            self.yeet.likes-=1
            self.session.removeLike(keyFromPost:yeet.key) // taking like out of list of likes
    
            self.session.removeUserToLikeList(postKey: self.yeet.key)
            self.session.managePostCounters(userKey: self.yeet.userId, key: yeet.key, command: "decrease_likes")
        }
        
    }

    func dislikeButtonPressed(){
        if self.thumbsdown == "hand.thumbsdown.fill"{ //disliked yeet
            print("DISLIKE")
            self.dislikes+=1
            self.yeet.dislikes+=1
            self.session.uploadDislike(dislikedPost: yeet.key)
            
            self.session.addUserToDislikeList(postKey: self.yeet.key)
            self.session.managePostCounters(userKey: self.yeet.userId, key: yeet.key, command: "increase_dislikes")
        } else { //undo dislike
            print("UNDO DISLIKE")
            self.dislikes-=1
            self.yeet.dislikes-=1
            self.session.updateDislikes(keyFromPost: yeet.key)
            
            self.session.removeUserToDislikeList(postKey: yeet.key)
            self.session.managePostCounters(userKey: self.yeet.userId, key: yeet.key, command: "decrease_dislikes")
        }
        
    }
    
    
}
