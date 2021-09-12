//
//  GithubSearchEndToEndTests.swift
//  WaveCodeTaskTests
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import XCTest
import RxSwift
import WaveCodeTask

class GithubSearchEndToEndTests: XCTestCase {

  func test_endToEndTestSearchResult_matchExpectData() {
    let disposeBag = DisposeBag()
    let searchName = "miguel"
    let exp = expectation(description: "Wait for api completion")

    var receivedResult: GithubSearchResult?
    var receivedError: GitHubServiceError?
    APIManager.shared.searchGithubUser(name: searchName)
      .subscribe { remoteResult in
        switch remoteResult {
        case let .success(result):
          receivedResult = result
        case let .failure(error):
          receivedError = error
        }
      } onCompleted: {
        exp.fulfill()
      }.disposed(by: disposeBag)

    wait(for: [exp], timeout: 5.0)

    XCTAssertNotNil(receivedResult, "Expected successful search result, got no result instead")
    XCTAssertEqual(receivedResult?.list.count, 30, "Expected 30 users count from result")
    XCTAssertNil(receivedError, "Expected successful feed result, got \(String(describing: receivedError?.localizedDescription)) instead")
  }
}
