//
//  ContentView.swift
//  Yeeter
//
//  Created by sam laitha on 11/14/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import ModalView
import Combine
import Firebase

struct ContentView : View {
    //@EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var session = SessionStore()
    @ObservedObject private var tabData = MainTabBarData(initialIndex: 1, customItemIndex: 2)
    
    
    @State var isPresented1 = false
    
    @State var completionHandlers: [() -> Void] = []
    
    @State var ans = ""
    //@EnvironmentObject var mymodel: GobalBool
    
    let user = Auth.auth().currentUser
    
  var body: some View {
    
            NavigationView {
                Group {
                  if (session.session != nil) {
             
                      TabView (selection: $tabData.itemSelected) {

                       //Home
                        ScrollView(){
                             ForEach(self.session.gettingPostsTest1) { yeet1 in
                                 PostCellView(session: self.session, yeet: yeet1)
                             }.padding(.trailing, 3)
                             .padding(.leading, 3)
                            
                         }
                        .padding(.top, 5)
                         .tabItem {
                             Image(systemName: "house")
                             Text("Home")
                         }.tag(1)

                       //Adding Yeets
                        Text("Modal")
                         .tabItem {
                             Image(systemName: "plus.circle")
                             Text("Yeet")
                         }.tag(2)
                       // Profile
                        ProfileView(session: session)
                           .tabItem {
                                Image(systemName: "person")
                               
                                Text("Profile")
                           }.tag(3)
                        // Search Users
                        //Text("Search")
                        SearchView()
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }.tag(4)

                           }
                           .sheet(isPresented: $tabData.isCustomItemSelected) {
                               //YeetView()
                               YeetView()
                            }
                        
                    .navigationBarItems(
                        trailing:
                        Button(action: { self.isPresented1.toggle()}) {
                                 Image("setting")
                                 .resizable()
                                 .frame(width: 18.1, height: 14.1)
                                 .foregroundColor(Color.black)
                             }.sheet(isPresented: $isPresented1) {
                                Section(header: Text("Setting")) {
                                    Form {
                                        Button(action: {
                                            self.session.signOut()
                                            self.isPresented1 = false
                                         }) {
                                             Text("Logout")
                                         }
//                                        .navigationBarTitle(Text(""))
                                    }
                            
                                }
                             }
                    )
                  } else {
                    SignInView()
                    .navigationBarItems(trailing: Text(""))
                  }
                }
                .navigationBarTitle(Text("\(session.usernameCurrent)"), displayMode: .inline)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                )
                .padding([.top, .horizontal])
                .edgesIgnoringSafeArea(.top)
                .onAppear() {
                    self.getUser()
                }
              }
        
        }
    
    func dismiss() {
        self.isPresented1 = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func getUser () {
        self.session.listen()
    }
    
    // This will set a like or dislike to the new posts coming in.
    func isLikedOrNot(yeet: Yeet ) ->String {
        var ans = "neither"
        for (_,value) in self.session.postsLiked {
            if yeet.key==value {
                //print(value)
                print("")
                print("LIKED")
                ans = "liked"
            }
        }

        for (_,value) in self.session.postsDisliked {
            if yeet.key==value {
                //print(value,"?")
                print("")
                print("ANS = DISLIKED")
                ans = "disliked"
            }
        }
        print("")
        print("Content view")
        print("value of ans: ",ans )
        return "disliked  "
    }
}


        

#if DEBUG
   struct ContentView_Previews : PreviewProvider {
       static var previews: some View {
           ContentView()
               .environmentObject(SessionStore())
       }
   }
   #endif
