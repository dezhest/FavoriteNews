//
//  NetworkService.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

class NetworkService {
    
    static func loadData(completion: @escaping ([Article]?) -> ()) {
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=2c13f090096a4afb9a5a6c746e102bf8"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, error == nil {
                
                let response = try? JSONDecoder().decode(ArticlesResponse.self, from: data)
                if let response = response {
                    DispatchQueue.main.async {
                        completion(response.articles)
                    }
                }
            } else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Failed to load news. Please try again later.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
}



final class ImageStore {

    static func downloadImageBy(url: String, completion: @escaping (UIImage)->Void) {
        
        guard let url = URL(string: url) else {
            print("failed to produce URL for image")
            return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
                } else {
                    print("failed to get Image from data")
                }
            } else {
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                if data == nil {
                    print("no data for Image")
                }
            }
        }
        task.resume()
    }
}
