//
//  ListViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import Foundation
import CoreData

class MainViewModel: ObservableObject {
    @Published var model = [MainModel]()

    @Published var news: [NewsCoreData] = []
    init() {
        fetchNetworkData()
    }
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    func fetchNetworkData() {
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
    func saveToCoreData(article: MainModel) {
        let newsInfo = NewsCoreData()
        newsInfo.id = article.id
        newsInfo.title = article.title
        newsInfo.urlToImage = article.urlToImage
        newsInfo.publishedAt = article.publishedAt
        CoreDataManager.instance.saveContext()
    }
    
    func deleteFromCoreData(article: MainModel) {
        let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        guard let result = try? CoreDataManager.instance.managedObjectContext.fetch(fetchRequest).first else { return }
        CoreDataManager.instance.managedObjectContext.delete(result)
        CoreDataManager.instance.saveContext()
    }
    
    func checkCoreDataContainDuplicate(image: String, article: MainModel) -> Bool {
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
    func onAppearfetchDataFavorited() {
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            news = results
        }
        catch {
            print("Error fetching data")
        }
    }
}

