
import SwiftUI
import Combine

struct SignInView : View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loading : Bool = false
    @State var error : Bool = false
    
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationMode.wrappedValue.dismiss()
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
    func signIn () {
        loading = true
        error = false
        displayIPActivityAlert()
        
        session.signIn(email: email, password: password) { (user, error) in
            self.loading = false
            self.dismissIPActivityAlert()
            if error != nil && user != nil{
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    var body: some View {
        VStack(spacing: 15) {
//               Image("signin")
//               .padding(.bottom, 30)
//                .padding(.top, 70)
//                .foregroundColor(.black)
                Text("YEETER")
                    .font(Font.custom("", size: 60))
                    .padding(.top, 120)
                    .padding(.bottom, 50)
                    .foregroundColor(.gray)
                    
               TextField("Email", text: $email)
                   .autocapitalization(.none)
               Divider()
               SecureField("Password", text: $password)
               Divider()
               .padding(.top, 10)
                //Spacer()
                   Button(action: signIn) {
                       HStack {
                           Text("Sign In")
                               .font(Font.custom("", size: 25))
                               .fontWeight(.ultraLight)
                               .foregroundColor(.black)
//                               .shadow(color: .gray, radius: 5, x: 1, y: 5)
                       }
                       .padding()
                       .frame(minWidth: 0, maxWidth: .infinity)
                       .background(Color.white)
                       .cornerRadius(5)
                       .shadow(color: .gray, radius: 5, x: 1, y: 5)
                   }
                   .padding()
               NavigationLink(destination: SignUpView()) {
                   Text("Create an Account")
                       .font(Font.custom("", size: 20))
                       .fontWeight(.ultraLight)
                       .foregroundColor(.black)
//                       .shadow(color: .gray, radius: 5, x: 1, y: 5)
               }
            Spacer()
            //Spacer()
           }
       .padding()
       }
}

extension UIAlertController {

    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
        ActivityIndicatorData.activityIndicator.color = UIColor.blue
        ActivityIndicatorData.activityIndicator.startAnimating()
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }

    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
#endif
