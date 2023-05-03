//
//  ListViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import Foundation

class ListViewModel: ObservableObject {
    
    @Published var articles = [ViewModel]()
    
    init() {
        fetchData()
        
    }

    private func fetchData() {
        NetworkService.loadData() { articles in
            if let articles = articles {
                self.articles = articles.map(ViewModel.init)
                self.imagesData()
            }
        }
    }
    
    private func imagesData(_ index: Int = 0) {
        guard articles.count > index else { return }
        let article = articles[index]
        if article.urlToImage != nil {
        ImageStore.downloadImageBy(url: article.urlToImage!) {
            self.articles[index].image = $0
            self.imagesData(index + 1)
        }
        } else {
            self.imagesData(index + 1)
        }
    }
}

