//
//  NewsRow.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI
import CoreData

struct NewsRow: View {
    @State private var showOverlay = false
    @State private var isTapped = false
    @State private var isImageShown = true
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    var article: ViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 10) {
                    if article.image != nil {
                        Image(uiImage: article.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                    Text(article.title)
                        .lineLimit(nil)
                        .font(.title2)
                }
                .padding(.top)
                .padding(.bottom)
                
                ZStack {
                    HStack(alignment: .firstTextBaseline) {
                        if let publishedAt = article.publishedAt {
                            Text(publishedAt)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    if !isTapped && !checkCoreDataContainDuplicate(image: article.title) {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .padding(10)
                            .onTapGesture {
                                print(isTapped)
                                print(checkCoreDataContainDuplicate(image: article.title))
                                isTapped = true
                                if checkCoreDataContainDuplicate(image: article.title) {
                                    deleteFromCoreData(article: article)
                                } else {
                                    saveToCoreData()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        if isTapped && checkCoreDataContainDuplicate(image: article.title) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.yellow)
                                .padding(10)
                                .onTapGesture {
                                    print("до \(isTapped)")
                                    print("до \(checkCoreDataContainDuplicate(image: article.title))")
                                    if !checkCoreDataContainDuplicate(image: article.title) && isTapped == true {
                                        isTapped = true
                                    } else {
                                        isTapped = false
                                    }
                                    
                                    if checkCoreDataContainDuplicate(image: article.title) {
                                        deleteFromCoreData(article: article)
                                    } else {
                                        saveToCoreData()
                                    }
                                    print("после \(isTapped)")
                                    print("после \(checkCoreDataContainDuplicate(image: article.title))")
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        } else {
                            if isImageShown {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.yellow)
                                    .padding(10)
                                    .onTapGesture {
                                        isImageShown = false
                                        if checkCoreDataContainDuplicate(image: article.title) {
                                            deleteFromCoreData(article: article)
                                        } else {
                                            saveToCoreData()
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
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

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: ListViewModel().articles[0])
        
    }
}

