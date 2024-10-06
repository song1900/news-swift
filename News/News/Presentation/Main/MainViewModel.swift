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
        case initial, fetchTopHeadlines, fetchTopHeadlinesNextPage, didSelectArticle(Article), updateArticleAsRead(Article)
    }
    enum Action {
        case didFetchTopHeadlines, showLoading(Bool), showDetail(Article)
    }
}

final class MainViewModel {
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private var currentPage = 1
    private var isFetching = false {
        didSet {
            Task { @MainActor in
                actionSubject.send(.showLoading(isFetching))
            }
        }
    }
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
                case .didSelectArticle(let article):
                    self?.actionSubject.send(.showDetail(article))
                case .updateArticleAsRead(let article):
                    self?.updateArticleAsRead(article)
                }
            }
            .store(in: &cancellables)
    }
}

extension MainViewModel {
    
    private func didSelectArticle(_ article: Article) {
        guard article.url != nil else { return }
        actionSubject.send(.showDetail(article))
    }
    
    private func updateArticleAsRead(_ article: Article) {
        guard let index = articles.firstIndex(where: { $0.title == article.title }) else { return }
        articles[index].isRead = true
    }
    
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
                
                saveArticlesToCoreData(articles: data.articles)
                
                actionSubject.send(.didFetchTopHeadlines)
            } catch {
                handleError(error)
                // 에러 발생 시 CoreData에서 데이터 가져오기
                loadArticlesFromCoreData()
            }
        }
    }
    
    private func loadArticlesFromCoreData() {
        let savedArticles = CoreDataManager.shared.fetch(ArticleEntity.self)
        guard !savedArticles.isEmpty else {
            return NSLog("CoreData에도 데이터가 없음.")
        }
        articles = savedArticles.map { Article(
            title: $0.title ?? "",
            url: $0.url ?? "",
            urlToImage: $0.urlToImage,
            publishedAt: $0.publishedAt ?? "",
            isRead: $0.isRead)
        }
        actionSubject.send(.didFetchTopHeadlines)
    }
    
    private func saveArticlesToCoreData(articles: [Article]) {
        let coreDataManager = CoreDataManager.shared
        let existingArticles = coreDataManager.fetch(ArticleEntity.self)
        let existingTitles = Set(existingArticles.map { $0.title })
            
        let newArticles = articles.filter { !existingTitles.contains($0.title) }
        
        guard !newArticles.isEmpty else { return }
        
        let articleData = newArticles.map {
            [
                "title": $0.title,
                "url": $0.url as Any,
                "urlToImage": $0.urlToImage as Any,
                "publishedAt" : $0.publishedAt as Any,
                "isRead" : $0.isRead
            ]
        }
        coreDataManager.batchInsert(ArticleEntity.self, data: articleData)
    }
    
    private func handleError(_ error: Error) {
        let errorLocalizedDescription: String
        switch error {
        case let networkError as NetworkError:
            errorLocalizedDescription = networkError.localizedDescription
        default:
            errorLocalizedDescription = error.localizedDescription
        }
        NSLog("Error in {\(#fileID)} : %@", errorLocalizedDescription)
    }
}
