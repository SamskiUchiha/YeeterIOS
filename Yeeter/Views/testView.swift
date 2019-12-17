import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

import SwiftUI

struct StargazersView: View {
    let imageUrl = "https://firebasestorage.googleapis.com/v0/b/yeeter-backend.appspot.com/o/userdefault.png?alt=media&token=e032ae63-095c-4983-80ac-3e2e3a73a0c8"

    var body: some View {
                //Text("Hello")
                ImageView(withURL: self.imageUrl)
                //Text(stargazer.login)
            
        }
    }


#if DEBUG
   struct StargazersView_Previews : PreviewProvider {
       static var previews: some View {
           StargazersView()
       }
   }
   #endif

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height:100)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
