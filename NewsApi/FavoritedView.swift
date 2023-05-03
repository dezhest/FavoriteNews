//
//  FavoritedView.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 03.05.2023.
//

import SwiftUI
import CoreData

struct FavoritedView: View {
    let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    @State private var news: [NewsCoreData] = []
    let imageCache = NSCache<NSString, UIImage>()
    var body: some View {
        List(news, id: \.self) { article in
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        if let imageUrlString = article.urlToImage, let imageUrl = URL(string: imageUrlString) {
                            AsyncImage(url: imageUrl) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
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
        }

        .id(UUID())
        .onAppear {
            do {
                let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                news = results
            }
            catch {
                print("Error fetching data")
            }
        }
    }
}

struct FavoritedView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedView()
    }
}
