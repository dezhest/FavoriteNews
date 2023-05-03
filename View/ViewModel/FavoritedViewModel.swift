//
//  FavoritedViewModel.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 03.05.2023.
//

import Foundation
import CoreData

class FavoritevViewModel: ObservableObject {
    @Published var model = FavoritedModel()
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    
    func deleteNews(article: NewsCoreData) {
        if let unwrapped = model.news.firstIndex(of: article) {model.indexOfEditScam = unwrapped}
        CoreDataManager.instance.managedObjectContext.delete(article)
        CoreDataManager.instance.saveContext()
    }
}
