//
//  FavoritedView.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 03.05.2023.
//

import SwiftUI
import CoreData

struct FavoritedView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        VStack {
            if viewModel.news.count == 0 {
                Text("Add your favorite news")
                    .font(.title)
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity, alignment: .center)
            }
                List {
                    ForEach(viewModel.news, id: \.self) { article in
                        HStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 10) {
                                    if let imageUrlString = article.urlToImage, let imageUrl = URL(string: imageUrlString) {
                                        AsyncImage(url: imageUrl) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .progressViewStyle(CircularProgressViewStyle())
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    }
                }
                .id(UUID())
                .onAppear {
                    viewModel.onAppearfetchDataFavorited()
                }
            }
    }
}

struct FavoritedView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedView()
    }
}
