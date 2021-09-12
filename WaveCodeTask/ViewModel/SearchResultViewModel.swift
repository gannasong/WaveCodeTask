//
//  SearchResultViewModel.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public class SearchResultViewModel: ViewModelType {
  private let disposeBag = DisposeBag()
  private var state: State = State()

  public enum SearchType {
    case newSearch(name: String)
    case requestNextPage
  }

  private struct State {
    var name: String = ""
    var list: [User] = []
    var nextPage: Int = 1
  }

  public struct Input {
    public let searchUserTrigger: Observable<SearchType>
    public let cancelTrigger: PublishSubject<Void>
  }

  public struct Output {
    public let list: BehaviorRelay<[User]>
    public let isLoading: BehaviorRelay<Bool>
    public let canLoadMore: BehaviorRelay<Bool>
    public let loadError: PublishSubject<String>
  }

  public func transform(input: Input) -> Output {
    let list = BehaviorRelay<[User]>(value: [])
    let loadError = PublishSubject<String>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let canLoadMore = BehaviorRelay<Bool>(value: false)

    input.searchUserTrigger
      .flatMapLatest { [unowned self] type -> Observable<Result<GithubSearchResult, GitHubServiceError>> in
        switch type {
        case let .newSearch(name: name):
          self.resetSearchState()
          self.state.name = name
          return requestNextPage(name: name)
            .retry(2)
        case .requestNextPage:
          return requestNextPage(name: self.state.name, nextPage: self.state.nextPage)
            .retry(2)
        }
      }.subscribe { response in
        switch response {
        case let .success(result):
          self.updateSearchState(result: result)
          list.accept(self.state.list)
          canLoadMore.accept(result.canLoadMore)
        case let .failure(error):
          loadError.onNext(error.displayMessage)
        }
      } onCompleted: {
        isLoading.accept(false)
      }.disposed(by: disposeBag)

    let cancelAction: ((()) -> Void)? = { [unowned self] _ in
      list.accept([])
      isLoading.accept(false)
      self.resetSearchState()
    }

    input.cancelTrigger
      .subscribe(onNext: cancelAction)
      .disposed(by: disposeBag)

    return Output(list: list, isLoading: isLoading, canLoadMore: canLoadMore, loadError: loadError)
  }

  // MARK: - Private Methods

  private func requestNextPage(name: String, nextPage: Int = 1) -> Observable<Result<GithubSearchResult, GitHubServiceError>> {
    return APIManager.shared.searchGithubUser(name: name, page: nextPage)
  }

  private func updateSearchState(result: GithubSearchResult) {
    state.nextPage = result.pageInfo.nextPage
    state.list.append(contentsOf: result.list)
  }

  private func resetSearchState() {
    state = State()
  }
}
