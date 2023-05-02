//
//  NewsRow.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 02.05.2023.
//

import SwiftUI

struct NewsRow: View {
   
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
                    Spacer()
                    if let publishedAt = article.publishedAt {
                    Text(publishedAt)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    }
                }
                .padding(.top)
            }
        }
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: ListViewModel().articles[0])
            
    }
}

