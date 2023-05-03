//
//  FavoritedNewsView.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI
import CoreData

struct FavoritedNewsView: View {
    let fetchRequest = NSFetchRequest<CoreDataNews>(entityName: "News")
    @State private var news: [New] = []
    var body: some View {
        NavigationView {
            List(favoritedNews, id: \.self) { article in
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
                    
                    HStack(alignment: .firstTextBaseline) {
                        if let publishedAt = article.publishedAt {
                            Text(publishedAt)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                
            }
            .onAppear {
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
        
    }
    
    
}

struct FavoritedNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedNewsView()
    }
}
