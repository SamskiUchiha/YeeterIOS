//
//  ProfileView.swift
//  Yeeter
//
//  Created by sam laitha on 11/19/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//

import SwiftUI
//import SwiftUIRefresh
import URLImage

struct ProfileView: View {
    @ObservedObject var session: SessionStore
    @State private var isShowing = false
    @State private var content = ContentView()
    
    @State var showingPicker = false
    @State var image : Image? = nil
    
    @State var followerAmount = 0
    @State var userLikesAmount = 0
    @State var userDislikesAmount = 0

    var body: some View {
        //ScrollView {
        NavigationView {
            ScrollView {
            ZStack{
                VStack {
                    
//                    ZStack {
           
                  
//                        Image("userdefault")
//                            .resizable()
//                            .frame(width: 170, height: 170, alignment: Alignment.center)
//                            //.aspectRatio(contentMode: .fit)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .shadow(radius: 5)
//                            .padding(.top, 10)
//                        image?
//                       // Image(systemName: "contact")
//                            .resizable()
//                            //.aspectRatio(contentMode: .fit)
//                            //.frame(width: 300)
//                            .frame(width: 170, height: 170, alignment: Alignment.center)
//                            .aspectRatio(contentMode: .fit)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .shadow(radius: 5)
//                            .padding(.top, 10)
//                        Button(action: { }) {
//                            Image(systemName: "camera")
//                            .resizable()
//                            .frame(width: 50, height: 35)
//                            .foregroundColor(.black)
//                        }
//                        .padding(.leading, 140)
//                        .padding(.top, 200)
//                            Button(action: {
//                                self.showingPicker = true
//                              //print("button pressed")
//
//                            }) {
//                                Image(systemName:"plus.circle.fill")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                                    .background(Circle()
//                                        .fill(Color.white)
//                                        .frame(width: 25, height: 25))
//
//                            }
//                            .padding(.top, 130)
//                            .padding(.leading, 125)
//
//                           .sheet(isPresented: self.$showingPicker,
//                                    onDismiss: {
//                                        // do whatever you need here
//                                    }, content: {
//                                        ImagePicker.shared.view
//                                    })
//                            .onReceive(ImagePicker.shared.$image) { image in
//                                // This gets called when the image is picked.
//                                // sheet/onDismiss gets called when the picker completely leaves the screen
//                                self.image = image
//                            }
//                    }
                    
            
 
                    Text("\(session.usernameCurrent)").font(.largeTitle)
                    
                    HStack{
                        Text("Followers: \(followerAmount)")
                        .padding()
                        Text("Likes: \(userLikesAmount)")
                        .padding()
                        Text("Dislikes: \(userDislikesAmount)")
                    }.padding(.bottom, 20)
                    
//                    HStack {
//                        Text("Followers: 329")
//                        .padding()
//                        Text("Likes: 13")
//                        .padding()
//                        Text("Yeets: 5")
//                    }.padding(.bottom, 20)

//                    Button(action: { }) {
//                        Text("Follow")
//                        .font(Font.custom("Courier", size: 20))
//                        .fontWeight(.ultraLight)
//                        .foregroundColor(.black)
//                    }.padding()
//                    .frame(minWidth: 0, maxWidth: 150, alignment: .center)
//                    .background(Color.orange)
//                    .cornerRadius(30)
//                    .shadow(color: .gray, radius: 5, x: 1, y: 5)
                }
            }
            .background(Color.clear)
            //Spacer()
            //.padding(.bottom, 30)
                ForEach(self.session.items) { yeet1 in
                    VStack {
                        PostCellView(session: self.session, yeet: yeet1)
                    }.padding(.trailing, 5)
                    .padding(.leading, 5)
                }
            }
                
//            .background(PullToRefresh(action: {
//                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                       self.isShowing = false
//                   }
//               }, isShowing: $isShowing))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            //.edgesIgnoringSafeArea(.top)
        }.onAppear(){
            self.getUser()
            self.getProfileInfo()
        }
        
     
           
    }
        
    
    func getUser () {
        self.session.listen()
    }
    
    func getProfileInfo(){
          self.session.getFollowersAmount { (Int) in
              self.followerAmount = Int
          }
          self.session.getUserLikesAmount { (Int) in
              self.userLikesAmount = Int
          }
          self.session.getUserDislikesAmount { (Int) in
              self.userDislikesAmount = Int
          }
      }

}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(session: session)
//    }
//}
