//
//  ContentView.swift
//  Example
//
//  Created by Ruyther Costa on 2024-06-19.
//

import SwiftUI

struct ContentView: View {
    @State private var responseData: String = "Loading..."

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding()
            ScrollView {
                Text(responseData)
                    .padding()
            }
        }
        .onAppear {
            makeNetworkCalls()
        }
    }

    func makeNetworkCalls() {
        // Using dataTask(with: URL)
        let firstURL = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let task1 = URLSession.shared.dataTaskPublisher(for: <#T##URL#>) dataTask(with: firstURL)
        task1.resume()

        // Using dataTask(with: URLRequest)
        let secondURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let request1 = URLRequest(url: secondURL)
        let task2 = URLSession.shared.dataTask(with: request1)
        task2.resume()

        // Using dataTask(with: URL, completionHandler)
        let thirdURL = URL(string: "https://jsonplaceholder.typicode.com/comments")!
        let task3 = URLSession.shared.dataTask(with: thirdURL) { data, response, error in
            print("Task3 done")
        }
        task3.resume()

        // Using dataTask(with: URLRequest, completionHandler)
        let forthURL = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let request2 = URLRequest(url: forthURL)
        let task4 = URLSession.shared.dataTask(with: request2) { data, response, error in
            print("Task4 done")
        }
        task4.resume()
    }
}
