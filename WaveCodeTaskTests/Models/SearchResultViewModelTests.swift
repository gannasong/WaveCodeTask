//
//  SearchResultViewModelTests.swift
//  WaveCodeTaskTests
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import XCTest
import WaveCodeTask
import RxSwift
import RxRelay
import RxTest

class SearchResultViewModelTests: XCTestCase {

  func test_search_searchUserFromSearchInputTrigger() {
    let disposeBag = DisposeBag()
    let scheduler = makeScheduler()
    let list = scheduler.createObserver([User].self)

    let (sut, loader) = makeSUT()
    let expectResult = makeSearchUserResult()
    loader.searchResult = expectResult

    let searchUserTrigger = PublishSubject<SearchResultViewModel.SearchType>()
    let cancelTrigger = PublishSubject<Void>()
    let input = SearchResultViewModel.Input(searchUserTrigger: searchUserTrigger, cancelTrigger: cancelTrigger)
    let output = sut.transform(input: input)

    output
      .list
      .skip(1)
      .bind(to: list)
      .disposed(by: disposeBag)

    scheduler.createColdObservable([.next(5, SearchResultViewModel.SearchType.newSearch(name: "a-user-name")), .next(10, SearchResultViewModel.SearchType.newSearch(name: "a-user-name"))])
      .bind(to: searchUserTrigger)
      .disposed(by: disposeBag)

    scheduler.start()

    XCTAssertEqual(list.events.count, 2, "Expected received 2 events in the scheduler")
    XCTAssertEqual(list.events, [.next(5, expectResult.list), .next(10, expectResult.list)])
  }

  func test_cancel_cleanListFromCancelInputTrigger() {
    let disposeBag = DisposeBag()
    let listScheduler = makeScheduler()
    let cleanScheduler = makeScheduler()
    let list = listScheduler.createObserver([User].self)
    let clean = cleanScheduler.createObserver(Void.self)

    let (sut, loader) = makeSUT()
    let expectResult = makeSearchUserResult()
    loader.searchResult = expectResult

    let searchUserTrigger = PublishSubject<SearchResultViewModel.SearchType>()
    let cancelTrigger = PublishSubject<Void>()

    let input = SearchResultViewModel.Input(searchUserTrigger: searchUserTrigger, cancelTrigger: cancelTrigger)
    let output = sut.transform(input: input)

    output
      .list
      .skip(1)
      .bind(to: list)
      .disposed(by: disposeBag)

    input
      .cancelTrigger
      .bind(to: clean)
      .disposed(by: disposeBag)

    listScheduler.createColdObservable([.next(5, SearchResultViewModel.SearchType.newSearch(name: "a-user-name"))])
      .bind(to: searchUserTrigger)
      .disposed(by: disposeBag)

    cleanScheduler.createColdObservable([.next(10, ())])
      .bind(to: cancelTrigger)
      .disposed(by: disposeBag)

    listScheduler.start()

    XCTAssertEqual(list.events.count, 1, "Expected received 1 list event in the scheduler")
    XCTAssertEqual(list.events, [.next(5, expectResult.list)])

    cleanScheduler.start()

    XCTAssertEqual(clean.events.count, 1, "Expected received 1 clean events in the scheduler")
    XCTAssertEqual(list.events.count, 2, "Expected received 2 list event in the scheduler")
    XCTAssertTrue(list.events[1].value.element!.isEmpty)
  }

  // MARK: - Helper

  func makeSUT() -> (sut: SearchResultViewModel, loader: APIManagerSpy) {
    let loader = APIManagerSpy()
    let sut = SearchResultViewModel(loader: loader)
    return (sut, loader)
  }

  func makeDisposeBag() -> DisposeBag {
    return DisposeBag()
  }

  func makeScheduler() -> TestScheduler {
    return TestScheduler(initialClock: 0)
  }

  func makeError() -> Error {
    return NSError(domain: "a-error", code: -1)
  }

  private func makeSearchUserResult() -> GithubSearchResult {
    let user = User(login: "a-user", avatar_url: "a-url.com")
    let pageInfo = PageInfo(nextPage: 2, lastPage: 30)
    return GithubSearchResult(list: [user], pageInfo: pageInfo)
  }

  class APIManagerSpy: SearchProtocol {
    var searchResult : GithubSearchResult?

    func searchGithubUser(name: String, page: Int) -> Observable<APIManager.SearchUserResponse> {
      if let result = searchResult {
        return Observable.just(.success(result))
      } else {
        return Observable.just(.failure(.connectivity))
      }
    }
  }

}
