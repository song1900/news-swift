//
//  DetailViewModel.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import Combine

extension DetailViewModel {
    enum State {
        case initial, loadWebView
    }
    enum Action {
        case loadWebView(String)
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
                    self?.loadWebView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadWebView() {
        let url = article.url
        actionSubject.send(.loadWebView(url))
    }
}
