//
//  ArticleListContracts.swift
//  NYTimesTimes
//
//  Created by ali naveed on 12/08/2025.
//
import Foundation
import Combine
import SwiftUI

// NOTE: SwiftUI View is a struct, so this protocol must *not* be class-only.
protocol ArticleListPresenterProtocol: AnyObject {
    var state: ArticleListPresenter.LoadState { get }
    var articles: [Article] { get }
    func onAppear()
    func retry()
    func destination(for article: Article) -> AnyView
}

protocol ArticleListInteractorProtocol: AnyObject {
    func fetchMostViewed(section: String, period: Int) -> AnyPublisher<[Article], Error>
}

protocol ArticleListRouterProtocol: AnyObject {
    func makeDetail(for article: Article) -> AnyView
}
