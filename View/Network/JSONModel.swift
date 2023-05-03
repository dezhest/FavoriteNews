//
//  JSONModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import Foundation

struct JSONModel: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
