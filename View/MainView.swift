//
//  ContentView.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI

struct MainView : View {
    @StateObject var viewModel = MainViewModel()
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            List(viewModel.model) { article in
                NewsRow(article: article)
                        .navigationTitle(Text("News"))
                }
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .tag(0)
                FavoritedView()
                    .tabItem {
                        Label("Favorite", systemImage: "star.fill")
                    }
                    .tag(1)
            }
        .environmentObject(viewModel)
        }
    }
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

