//
//  ContentView.swift
//  NetworkLayerIOS
//
//  Created by Shahrukh on 29/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("Tap to create post")
                .font(.footnote)
        }
        .padding()
        .onTapGesture {
            Task {
                await createPost()
            }
        }
    }
    
    func createPost() async {
        let request = PostRequest(title: "foo", body: "bar", userId: 1)
        let result = await AppService().createPost(request: request)
        
        switch result {
        case .success(let success):
            dump(success)
        case .failure(let error):
            dump(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
