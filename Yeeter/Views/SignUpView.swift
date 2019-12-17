import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import FirebaseDatabase


struct SignUpView : View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var loading : Bool = false
    @State private var canSignUp: Bool = false
    @State private var isUsernameAlreadyExist: Bool = false
    @State private var isEmailAlreadyExist: Bool = false
    @State private var alertMsg: String = ""
    @State private var alertMsgEmail: String = ""
    //@State var error : Bool = false
    @State private var isOn = true
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
     var body: some View {
           Group {
               VStack {
                    VStack {
//                        Image("signup")
//                          .resizable()
//                          .frame(width: 250.0, height: 110.0)
                          //.padding(.bottom, 20)
                        Text("Sign Up")
                        .font(Font.custom("", size: 60))
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        .foregroundColor(.gray)
                    }
                    
                  
                   HStack {
                       //Text("Username")
                       TextField("Username", text: $username)
                        .modifier(TextModifier())
                   }
                   .padding()
                   .padding(.horizontal, 15)
                   HStack {
                      // Text("Email")
                       TextField("Email Address", text: $email)
                        .modifier(TextModifier())
                   }
                   .padding()
                   .padding(.horizontal, 15)
                    
                
                    HStack {
                        ZStack {
                        //Text("Password")
                        if isOn {
                            SecureField("Password", text: $password)
                                 .modifier(TextModifier())
                        } else {
                            TextField("Password", text: $password)
                                 .modifier(TextModifier())
                            
                        }
                        Toggle(isOn: $isOn) {
                            Text("")
                        }.padding(.leading, 250)
                        }
                    }
                    .padding()
                    //.padding(.bottom, 20)
                    .padding(.horizontal, 15)
                    
                    Button(action: {

                            self.usernameExists(username: self.username) { (isExist) in
                                if isExist {
                                    self.alertMsg  = "\(self.username) is already taken. Please try again."
                                    self.isUsernameAlreadyExist.toggle()
                                } else {
                                    self.signUp()
                                }
                        }
                     }) {
                         Text("Sign up")
                         .font(Font.custom("", size: 25))
                         .fontWeight(.ultraLight)
                         .foregroundColor(.black)
                    }.disabled(self.username.isEmpty || self.email.isEmpty || self.password.isEmpty)
                   .padding()
                   .frame(minWidth: 0, maxWidth: 320)
                   .background(Color.white)
                   .cornerRadius(5)
                   .shadow(color: .gray, radius: 5, x: 1, y: 5)
                   .alert(isPresented: $isUsernameAlreadyExist) { () -> Alert in
                        Alert(title: Text("uhh oh!"), message: Text(alertMsg), dismissButton: .default(Text("Okay")))
                    }
                    Spacer()
                    
               }
               .toggleStyle(MyToggleStyle())
           }
           .padding()
            
       }
    //Functions -----------------------------
    
        func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            presentationMode.wrappedValue.dismiss()
        }
        
         
        func signUp () {
            displayIPActivityAlert()
            loading = true
            //error = false
            print("Email!!!!: \(self.email)")
            session.signUp(email: email, password: password) { (user, error) in
                self.loading = false
                self.dismissIPActivityAlert()
                if error != nil && user != nil{
                    //self.error = true
                    print("Cannot create email/password!")
                    print("Error \(error!.localizedDescription)")
                } else {
                    print("Created a new user!")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.username
                    changeRequest?.commitChanges { error in
                        if error == nil{
                            print("User display name created! \(self.username) and \(self.email)")
                            // save username to firebase
                            self.uploadUser(newusername: self.username) { success in
                                if (success != nil) {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        } else {
                            print("Error \(error!.localizedDescription)")
                        }
                    }
//                    self.email = ""
                    self.password = ""
                }
            }
        }
        
    func uploadUser (newusername: String, completion: ((Error?) -> ())?) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let dataRef = Database.database().reference().child("users/\(uid)")
            
        let usernamesRef = Database.database().reference(withPath: "usernamesRef")
        let newUsername = usernamesRef.child("/\(newusername)")
        newUsername.setValue(uid)

        let userObj = User(uid: uid, username: newusername)
        dataRef.setValue(userObj.toAnyObject()) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
            //let username
    }
    
        func usernameExists(username: String, completion: @escaping(Bool) -> Void) {
            let usernamesRef = Database.database().reference(withPath: "usernamesRef")
            
            usernamesRef.observe(DataEventType.value) { (snapshot) in
                if snapshot.childSnapshot(forPath: username).exists() {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }

    
        func checkUnqiueEmail(email: String, completion: @escaping(Bool) -> Void) {
            let dataRef = Database.database().reference()
            dataRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: {(snaphot: DataSnapshot) in
                    if snaphot.exists() {
                        completion(true)
                    } else {
                        completion(false)
                    }
            })
        }
        private struct activityAlert {
            static var activityIndicatorAlert: UIAlertController?
        }
        
        //completion : ((Int, String) -> Void)?)
        func displayIPActivityAlert() {
            activityAlert.activityIndicatorAlert = UIAlertController(title: NSLocalizedString("Loading...", comment: ""), message: nil , preferredStyle: UIAlertController.Style.alert)
            activityAlert.activityIndicatorAlert!.addActivityIndicator()
            var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while ((topController.presentedViewController) != nil) {
                topController = topController.presentedViewController!
            }

    //        activityAlert.activityIndicatorAlert!.addAction(UIAlertAction.init(title:NSLocalizedString("Cancel", comment: ""), style: .default, handler: { (UIAlertAction) in
    //                self.dismissIPActivityAlert()
    //                onCancel?()
    //        }))
            topController.present(activityAlert.activityIndicatorAlert!, animated:true, completion:nil)
        }

        func dismissIPActivityAlert() {
            activityAlert.activityIndicatorAlert!.dismissActivityIndicator()
            activityAlert.activityIndicatorAlert = nil
        }
}

struct MyToggleStyle: ToggleStyle {
    let width: CGFloat = 50
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label

            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: width, height: width / 2)
                    .foregroundColor(configuration.isOn ? .green : .red)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: (width / 2) - 4, height: width / 2 - 6)
                    .padding(4)
                    .foregroundColor(.white)
                    .onTapGesture {
                        withAnimation {
                            configuration.$isOn.wrappedValue.toggle()
                        }
                }
            }
        }
    }
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocapitalization(.none)
            .padding(.all)
            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
    }
}

#if DEBUG
struct SignUpView_Previews : PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
#endif
