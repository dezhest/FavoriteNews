//
//  NewsRowViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 04.05.2023.
//

import Foundation
import CoreData

class NewsRowViewModel: ObservableObject {
    @Published var model = NewsRowModel()
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    
    func saveToCoreData() {
        let newsInfo = NewsCoreData()
        newsInfo.id = article.id
        newsInfo.title = article.title
        newsInfo.urlToImage = article.urlToImage
        newsInfo.publishedAt = article.publishedAt
        CoreDataManager.instance.saveContext()
    }
    
    func deleteFromCoreData(article: ViewModel) {
        let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        guard let result = try? CoreDataManager.instance.managedObjectContext.fetch(fetchRequest).first else { return }
        CoreDataManager.instance.managedObjectContext.delete(result)
        CoreDataManager.instance.saveContext()
    }
    
    func checkCoreDataContainDuplicate(image: String) -> Bool {
        var contains = false
        for i in fetchData() {
            if i.urlToImage == article.urlToImage {
                contains = true
            }
        }
        if !contains {
            return false
        } else {
            return true
        }
    }
    
    func fetchData() -> [NewsCoreData]{
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }
        catch {
            print("Error fetching data")
            return []
        }
    }
    
}

