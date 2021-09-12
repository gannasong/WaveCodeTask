//
//  APIManager+Search.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation
import RxSwift

public protocol SearchProtocol {
  func searchGithubUser(name: String, page: Int) -> Observable<APIManager.SearchUserResponse>
}

extension APIManager: SearchProtocol {
  public typealias SearchUserResponse = Result<GithubSearchResult, GitHubServiceError>

  public func searchGithubUser(name: String, page: Int = 1) -> Observable<SearchUserResponse> {
    return provider.rx.request(.serachUser(name: name, page: page))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .mapPageInfoResult()
      .mapUserListResult()
      .catchError { error in
        // The GitHub interface has a limit on the frequency of requests, too frequently will be rejected: 403
        return Observable.of(.failure(.limitReached))
      }
  }
}
