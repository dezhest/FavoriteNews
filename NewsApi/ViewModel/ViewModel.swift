//
//  ViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI

struct ViewModel: Identifiable {
    
    let id = UUID()
    
    let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    var title: String {
        return self.article.title
    }
    
    var urlToImage: String? {
        return self.article.urlToImage
    }
    
    var image: UIImage?
    
    var publishedAt: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = df.date(from: self.article.publishedAt) {
            df.dateStyle = .medium
            df.timeStyle = .short
            return df.string(from: date)
        } else {
            return ""
        }
    }
}

