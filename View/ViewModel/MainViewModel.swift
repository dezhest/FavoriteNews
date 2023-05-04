//
//  ListViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var model = [MainModel]()
    @Published var article: MainModel?
    init() {
        fetchData()
    }
    
    private func fetchData() {
        NetworkService.loadData() { articles in
            if let articles = articles {
                self.model = articles.map(MainModel.init)
                self.imagesData()
            }
        }
    }
    
    private func imagesData(_ index: Int = 0) {
        guard model.count > index else { return }
        let article = model[index]
        if article.urlToImage != nil {
            ImageStore.downloadImageBy(url: article.urlToImage!) {
                self.model[index].image = $0
                self.imagesData(index + 1)
            }
        } else {
            self.imagesData(index + 1)
        }
    }
}

