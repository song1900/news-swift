//
//  MainViewModel.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import Foundation
import Combine

extension MainViewModel {
    enum State {
        case initial, fetchTopHeadlines, fetchTopHeadlinesNextPage
    }
    enum Action {
        case didFetchTopHeadlines
    }
}

final class MainViewModel {
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private var currentPage = 1
    private var isFetching = false
    private var articlesTotalCount = 0
    private(set) var articles: [Article] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        bindState()
    }
}

extension MainViewModel {
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .fetchTopHeadlines:
                    self?.fetchTopHeadlines()
                case .fetchTopHeadlinesNextPage:
                    self?.fetchTopHeadlinesNextPage()
                }
            }
            .store(in: &cancellables)
    }
}

extension MainViewModel {
    private func fetchTopHeadlinesNextPage() {
        guard !isFetching && (articles.count < articlesTotalCount) else { return }
        fetchTopHeadlines()
    }
    
    private func fetchTopHeadlines() {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            defer { isFetching = false }
            
            guard let apiKey = AppConfiguration.apiKey else {
                throw NetworkError.missingApiKey
            }
            guard let apiBaseUrl = AppConfiguration.apiBaseURL else {
                throw NetworkError.missingApiBaseURL
            }
            do {
                let urlString = apiBaseUrl + "/top-headlines?country=us&page=\(currentPage)"
                var requestBuilder = URLRequestBuilder(url: urlString)
                requestBuilder.addHeader(field: "X-Api-Key", value: apiKey)
                
                let response = try await Request().responseAsync(with: requestBuilder)
                if let error = response.error {
                   throw error
                }
                guard let data: NewsResponse = response.decode() else {
                    throw NetworkError.decodingFailed
                }
                currentPage += 1
                articlesTotalCount = data.totalResults
                articles += data.articles
                
                actionSubject.send(.didFetchTopHeadlines)
                
            } catch {
                NSLog("ERROR \(error.localizedDescription)")
            }
        }
    }
}
