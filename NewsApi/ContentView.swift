//
//  ContentView.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI

struct ContentView : View {
    @StateObject var model: ListViewModel = ListViewModel()
    @State private var selectedTab = 0
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                List(model.articles) { article in
                    NewsRow(article: article)
                }
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .tag(0)
                Image(systemName: "globe")
                    .tabItem {
                        Label("Favorite", systemImage: "star.fill")
                    }
                    .tag(1)
                    .navigationTitle(Text("News"))
            }
        }
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

