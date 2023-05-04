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
    @State var isTapped = false
    @State var isImageShown = true
    var article: MainModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    if article.image != nil {
                        Image(uiImage: article.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .progressViewStyle(CircularProgressViewStyle())
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
                    if !isTapped && !viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .padding(10)
                            .onTapGesture {
                                isTapped = true
                                if viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) {
                                    viewModel.deleteFromCoreData(article: article)
                                } else {
                                    viewModel.saveToCoreData(article: article)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        if isTapped && viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.yellow)
                                .padding(10)
                                .onTapGesture {
                                    if !viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) && isTapped == true {
                                        isTapped = true
                                    } else {
                                        isTapped = false
                                    }
                                    
                                    if viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) {
                                        viewModel.deleteFromCoreData(article: article)
                                    } else {
                                        viewModel.saveToCoreData(article: article)
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
                                        if viewModel.checkCoreDataContainDuplicate(image: article.title, article: article) {
                                            viewModel.deleteFromCoreData(article: article)
                                        } else {
                                            viewModel.saveToCoreData(article: article)
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
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow(article: MainViewModel().model[0])
        
    }
}

