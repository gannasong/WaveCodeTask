//
//  ParseRemoteLinkTestCases.swift
//  WaveCodeTaskTests
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import XCTest
import RxSwift
import Alamofire
import WaveCodeTask

class ParseRemoteLinkTestCases: XCTestCase {

  func test_parse_parseRemoteLinksToDictionary() {
    let links = anyLinks()

    var receivedResult = [String: Int]()
    do {
      receivedResult = try ParserHelper.parseLinkToDic(links)
    } catch {
      XCTFail("Expected parse success but got \(error) message.")
    }

    XCTAssertEqual(receivedResult.count, 4)
    XCTAssertEqual(receivedResult["first"], 1)
    XCTAssertEqual(receivedResult["prev"], 2)
    XCTAssertEqual(receivedResult["next"], 4)
    XCTAssertEqual(receivedResult["last"], 34)
  }

  func test_parse_parsePaginationFromHeader() {
    let headers = anyHeaders()

    let (nextPage, lastPage) = ParserHelper.parsePaginationFromHeader(headers: headers)

    XCTAssertEqual(nextPage, 4)
    XCTAssertEqual(lastPage, 34)
  }

  func test_parse_parsePaginationNumber() {
    let link = anyLink(page: 7)

    let parsePage = ParserHelper.parsePaginationNumber(url: link)

    XCTAssertEqual(parsePage, 7)
  }
  // MARK: - Helpers

  private func anyLink(page: Int) -> String {
    return "<https://api.github.com/search/users?q=miguelq&page=\(page)&q=Rf>; rel=\"next\""
  }
  
  private func anyLinks(prev: Int = 2, next: Int = 4, last: Int = 34) -> String {
    return "<https://api.github.com/search/users?q=miguelq&page=\(prev)&q=Rf>; rel=\"prev\" <https://api.github.com/search/users?q=miguelq&page=\(next)&q=Rf>; rel=\"next\" <https://api.github.com/search/users?q=miguelq&page=\(last)&q=Rf>; rel=\"last\" <https://api.github.com/search/users?q=miguelq&page=1&q=Rf>; rel=\"first\""
  }

  private func anyHeader() -> HTTPHeader {
    return HTTPHeader(name: "Link", value: anyLinks())
  }

  private func anyHeaders() -> HTTPHeaders {
    return HTTPHeaders([anyHeader()])
  }
}
