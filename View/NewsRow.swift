//
//  NewsRow.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI
import CoreData

struct NewsRow: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var showOverlay = false
    @State private var isTapped = false
    @State private var isImageShown = true
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")

    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    if viewModel.article?.image != nil {
                        Image(uiImage: viewModel.article?.image! ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    Spacer()
                    Text(viewModel.article?.title ?? "")
                        .lineLimit(nil)
                        .font(.title2)
                }
                .padding(.top)
                .padding(.bottom)
                
                ZStack {
                    HStack(alignment: .firstTextBaseline) {
                        if let publishedAt = viewModel.article?.publishedAt {
                            Text(publishedAt)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    if !isTapped && !checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "") {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .padding(10)
                            .onTapGesture {
                                isTapped = true
                                if checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "") {
                                    deleteFromCoreData(article: viewModel.article!)
                                } else {
                                    saveToCoreData()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        if isTapped && checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "") {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.yellow)
                                .padding(10)
                                .onTapGesture {
                                    if !checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "" ) && isTapped == true {
                                        isTapped = true
                                    } else {
                                        isTapped = false
                                    }
                                    
                                    if checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "") {
                                        deleteFromCoreData(article: viewModel.article!)
                                    } else {
                                        saveToCoreData()
                                    }
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
                                        if checkCoreDataContainDuplicate(image: viewModel.article?.title ?? "") {
                                            deleteFromCoreData(article: viewModel.article!)
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
        newsInfo.title = viewModel.article?.title ?? ""
        newsInfo.urlToImage = viewModel.article?.urlToImage
        newsInfo.publishedAt = viewModel.article?.publishedAt ?? ""
        CoreDataManager.instance.saveContext()
    }
    
    func deleteFromCoreData(article: MainModel) {
        let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        guard let result = try? CoreDataManager.instance.managedObjectContext.fetch(fetchRequest).first else { return }
        CoreDataManager.instance.managedObjectContext.delete(result)
        CoreDataManager.instance.saveContext()
    }
    
    func checkCoreDataContainDuplicate(image: String) -> Bool {
        var contains = false
        for i in fetchData() {
            if i.urlToImage == viewModel.article?.urlToImage {
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
        NewsRow()
    }
}

