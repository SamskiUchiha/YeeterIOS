//
//  SearchView.swift
//  Yeeter
//
//  Created by sam laitha on 11/24/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.


//              README          //
// For this view, a user can search, follow and unfollow a user.
// When the search button is clicked, checkUser() is called.
// CheckUser() checks to see if the username entered is valid.
// If the username is valid, session.isFollowing is called to
// see if current user is following searched username. if so,
// icon is filled, if not, the icon is not filled.
// When the followIcon is is clicked, session.followUser or
// session.unfollowUser is called. FollowIcon changes depending
// if following or not.



import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var session = SessionStore()
    
    @State private var userSearch: String = ""
    @State var copy: String = ""
    @State var followIcon: String = ""
    
    //@State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        //Text("Hello World!")
        VStack{
            HStack {
                HStack {
                    
                    Image(systemName: "magnifyingglass")
                    TextField("search", text: $userSearch, onEditingChanged: {isEditing in
                       self.showCancelButton = true
                   }, onCommit: {
                       print("onCommit")
                   }).foregroundColor(.primary)
                   .autocapitalization(.none)
                   
                   Button(action: {
                    self.userSearch = ""
                   }) {
                       //Image(systemName: "checkmark")
                       //Text("Search")
                       Image(systemName: "xmark.circle.fill").opacity(userSearch == "" ? 0:1)
                   }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                .padding(.top, 10)
                
                if showCancelButton  {
                    Button("Search") {
                             UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                             self.checkUser(input: self.userSearch)
                             self.showCancelButton = false
                            
                     }
                    .padding()
                    Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.followIcon = ""
                            self.userSearch = ""
                            self.showCancelButton = false
                        
                    }
                    .foregroundColor(Color(.systemBlue))
                }
                
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
           
            
            List {
                
                if self.followIcon != "" {
                    HStack {
                        Text(self.copy)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button(action: {
                             //  When button is pressed, either the person is following the user or not. if
                             // the followIcon is "filled" when pressed, unfollow. Follow if followIcon is
                             // "unfilled" when pressed. Update fill Icon in both cases
                             
                             if self.followIcon == "person.badge.plus.fill" { // user is following
                                 self.session.unfollowUser(username: self.copy)
                                 self.followIcon = "person.badge.plus" // update to unfollow
                             } else if self.followIcon == "person.badge.plus" { // user is not following
                                 self.session.followUser(username: self.copy)
                                 self.followIcon = "person.badge.plus.fill" // update to following
                             }
                             
                         }) {
                             Image(systemName:followIcon)
                         }
                        Spacer()
                    }
 
                } else {
                    if self.userSearch != ""{
                        Text("User Does Not Exist")
                    }
                }
            }
            .navigationBarTitle(Text("Search"), displayMode: .large)
            .resignKeyboardOnDragGesture()
            
        }
    }
    
    func checkUser(input: String){
        self.copy = self.userSearch // to make sure that the displaying name does not change when user to follow pops up
        if input == ""{
            return
        }
        
        // first check if user exists
        self.session.checkUser(username: input) { (userExists) in
            if userExists {
                print("user exists")
                
                // user exists. Time to see if the person is already following that user
                self.session.isFollowingUser(username: input) { (following) in
                    if following {
                        //print(input," is following")
                        self.followIcon = "person.badge.plus.fill"
                    } else {
                        //print(input," is not following")
                        self.followIcon = "person.badge.plus"
                    }
                }
                
            } else {
                self.followIcon = ""
                print("user does not exist")
            }
        }
    }
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
