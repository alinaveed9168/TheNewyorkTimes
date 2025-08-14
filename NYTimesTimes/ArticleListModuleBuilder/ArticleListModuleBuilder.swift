//
//  ArticleListModuleBuilder.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import Foundation
import SwiftUI

enum ArticleListModuleBuilder {
    static func makeView() -> some View {
        let repo = AppEnvironment.makeRepository()
        let interactor = ArticleListInteractor(repository: repo)
        let router = ArticleListRouter()
        let presenter = ArticleListPresenter(interactor: interactor, router: router)
        let view = ArticleListView(presenter: presenter)
        return view
    }
}
