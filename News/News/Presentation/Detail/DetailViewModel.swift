//
//  DetailViewModel.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import Combine
import Foundation

extension DetailViewModel {
    enum State {
        case initial, loadWebView, didFinishLoadWebView, didFailLoadView(Error)
    }
    enum Action {
        case loadWebView(String), didMarkArticleAsRead(Article), showLoading(Bool)
    }
}

final class DetailViewModel {
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    private(set) var article: Article
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(article: Article) {
        self.article = article
        bindState()
    }
}

extension DetailViewModel {
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .loadWebView:
                    self?.updateArticleToCoreData()
                    self?.loadWebView()
                case .didFinishLoadWebView:
                    self?.handleLoading(false)
                case .didFailLoadView(let error):
                    self?.didFailLoadView(error: error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleLoading(_ val: Bool) {
        actionSubject.send(.showLoading(val))
    }
    
    private func didFailLoadView(error: Error) {
        handleLoading(false)
        NSLog("Failed to load WKWebView: %@", error.localizedDescription)
    }
    
    private func loadWebView() {
        handleLoading(true)
        let url = article.url
        actionSubject.send(.loadWebView(url))
    }
    
    private func updateArticleToCoreData() {
        let title = article.title
        let predicate = NSPredicate(format: "title == %@", title)
        actionSubject.send(.didMarkArticleAsRead(article))
        CoreDataManager.shared.update(ArticleEntity.self, predicate: predicate) {
            $0.isRead = true
        }
    }
}
