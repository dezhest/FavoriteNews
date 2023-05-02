//
//  NewsRow.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI

struct NewsRow: View {
    @State private var showOverlay = false
    @State private var isTapped = false
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
                
                HStack(alignment: .firstTextBaseline) {
                    if let publishedAt = article.publishedAt {
                        Text(publishedAt)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                  Image(systemName: "star")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .colorMultiply(isTapped ? .yellow : .white)
                        .padding(10)
                        .onTapGesture {
                            isTapped.toggle()
                            saveToCoreData()
                        }
                        
                }
                .padding(.top)
            }
        }
    }
    func saveToCoreData() {
        let newsInfo = NewsCoreData()
        newsInfo.title = article.title
        newsInfo.urlToImage = article.urlToImage
        newsInfo.publishedAt = article.publishedAt
        CoreDataManager.instance.saveContext()
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: ListViewModel().articles[0])
        
    }
}

