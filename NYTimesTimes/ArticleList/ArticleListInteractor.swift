//
//  ArticleListInteractor.swift
//  NYTimesTimes
//
//  Created by ali naveed on 12/08/2025.
//

import Foundation
import Combine

final class ArticleListInteractor: ArticleListInteractorProtocol {
    private let repository: ArticlesRepository

    init(repository: ArticlesRepository) {
        self.repository = repository
    }

    func fetchMostViewed(section: String = "all-sections", period: Int = 7) -> AnyPublisher<[Article], Error> {
        repository.mostViewed(section: section, period: period)
    }
}
