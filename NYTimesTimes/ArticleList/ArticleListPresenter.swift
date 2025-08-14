import Combine
//
//  ArticleListPresenter.swift
//  NYTimesTimes
//
//  Created by ali naveed on 12/08/2025.
//
import Foundation
import SwiftUI

final class ArticleListPresenter: ObservableObject, ArticleListPresenterProtocol
{
    enum LoadState: Equatable {
        case idle, loading, loaded
        case failed(String)
    }

    @Published var state: LoadState = .idle
    @Published var articles: [Article] = []

    private let interactor: ArticleListInteractorProtocol
    private let router: ArticleListRouterProtocol
    private var bag = Set<AnyCancellable>()

    init(
        interactor: ArticleListInteractorProtocol,
        router: ArticleListRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }

    func onAppear() {
        if case .idle = state { load() }
    }

    func retry() { load() }

    private func load() {
        state = .loading
        interactor.fetchMostViewed(section: "all-sections", period: 7)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state = .loaded
                case .failure(let error):
                    self?.state = .failed(
                        (error as NSError).localizedDescription
                    )
                }
            } receiveValue: { [weak self] in
                self?.articles = $0
            }
            .store(in: &bag)
    }

    func destination(for article: Article) -> AnyView {
        router.makeDetail(for: article)
    }
}
