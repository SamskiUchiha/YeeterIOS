//
//  ContentView.swift
//  SwiftUIFirebase
//
//  Created by Mark Kinoshita on 10/29/19.
//  Copyright © 2019 Mark Kinoshita. All rights reserved.
//

import SwiftUI

struct YeetView: View {
    
      //MARK: Properties
    @State private var newYeet: String = ""
    @State private var isLimit = false
    
    @ObservedObject var session = SessionStore()
    @State private var isOn = false
    
    @Environment(\.presentationMode) private var presentationMode
    
//    func checklimit() {
//        if newYeet.count >= 9 {
//            self.isLimit.toggle()
//        }
//    }
//    func countChar() -> String {
//        return String(self.newYeet.count)
//    }
    
    func checklimit(str: String, completion: @escaping(Bool) -> Void) {
        if str.count > 240 {
            completion(false)
        } else {
            completion(true)
        }
    }
    var body: some View {
        Group {
            
//                VStack(alignment: .leading) {
//                    HStack {
//                        //Text("Yeet:")
//                        TextField("What's happening?", text: $newYeet)
//                            .foregroundColor(.white)
//
//
//                    }
//                     Text(newYeet)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        //.frame(width: 50, height: 170, alignment: Alignment.center)
//                        .font(.title)
//                        .foregroundColor(.black)
//                        .onAppear { self.newYeet = "" }
//                        .lineLimit(nil)
//
//                }
            VStack {
//                Text("text is: \(newYeet)")
                TextView(
                    text: $newYeet
                )
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 300)
                    .padding(.top, 10)
                    .padding()
                    .shadow(radius: 2)
                    .cornerRadius(2.2)
                    //.font(.system(size: 40))
            }
            
            


            Button(action: {
                self.checklimit(str: self.newYeet) { isGood in
                    if isGood {
                        self.addYeet()
                    } else {
                        
                        self.isOn.toggle()
                    }
                }
//                self.checklimit()
//
//                if self.isLimit {
//                    self.isOn.toggle()
//                } else {
//                    self.addYeet()
//                }
               
           }) {
               Text("YEET")
                .frame(minWidth: 0, maxWidth: 300)
                .font(Font.custom("", size: 30))
               .foregroundColor( .black)
               .padding()
                .background(Color(.white))
               .cornerRadius(5)
               .shadow(radius: 6)
            }.disabled(self.newYeet.isEmpty)
            Spacer()
            //Text(self.countChar()).bold()
        }.alert(isPresented: $isOn) { () -> Alert in
            Alert(title: Text("Word limit exceeded!"), message: Text("Character Limit of 240 was exceeded."), dismissButton: .default(Text("Okay")))
        }
    }
    
    func addYeet() {
        if !newYeet.isEmpty {
            //Add TODO to Firebase
            session.uploadPost(yeet: newYeet)
            dismiss()
        }
    }
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
        //presentationMode.wrappedValue = false
    }

}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "Times", size: 30)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.3, alpha: 0.05)
        myTextView.insertText("What's happening?")

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}
