//
//  ArticleListRouter.swift
//  NYTimesTimes
//
//  Created by ali naveed on 12/08/2025.
//
import SwiftUI

final class ArticleListRouter: ArticleListRouterProtocol {
    func makeDetail(for article: Article) -> AnyView {
        AnyView(ArticleDetailView(article: article))
    }
}
