//
//  APIManager+Observables.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation
import RxSwift
import Moya

extension Observable {
  public typealias PageInfoResult = (Moya.Response, PageInfo)

  public func mapPageInfoResult() -> Observable<Result<PageInfoResult, GitHubServiceError>> {
    return map { element in
      guard let res = element as? Moya.Response, res.statusCode == 200, let headers = res.response?.headers else {
        return .failure(.connectivity)
      }

      let (nextPage, lastPage) = ParserHelper.parsePaginationFromHeader(headers: headers)
      let pageInfo = PageInfo(nextPage: nextPage, lastPage: lastPage)
      return .success((res, pageInfo))
    }
  }

  public func mapUserListResult() -> Observable<Result<GithubSearchResult, GitHubServiceError>> {
    return map { element in
      guard let pageInfoResult = element as? Result<PageInfoResult, GitHubServiceError> else {
        return .failure(.invalidData)
      }

      switch pageInfoResult {
      case let .success(result):
        let user = try (result.0 as Response).map([User].self, atKeyPath: "items")
        let pageInfo = result.1
        let searchUserResult = GithubSearchResult(list: user, pageInfo: pageInfo)
        return .success(searchUserResult)
      case let .failure(error):
        return .failure(error)
      }
    }
  }
}
