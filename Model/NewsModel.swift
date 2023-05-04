//
//  NewsModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 04.05.2023.
//

import Foundation
import UIKit

struct NewsModel: Identifiable {
    
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
                df.timeZone = TimeZone.current
                df.dateStyle = .medium
                df.timeStyle = .short
                return df.string(from: date)
            } else {
                return ""
            }
        }
}
