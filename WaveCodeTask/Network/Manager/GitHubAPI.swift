//
//  GitHubAPI.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/11.
//

import Foundation
import Moya

enum GitHubAPI {
  case serachUser(name: String, page: Int)
}

extension GitHubAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }

  public var path: String {
    switch self {
    case .serachUser:
      return "search/users"
    }
  }

  public var method: Moya.Method {
    return .get
  }

  public var sampleData: Data {
    return "{}".data(using: String.Encoding.utf8)!
  }

  private var parameters: [String: Any]? {
    var parameters: [String: Any] = [:]

    switch self {
    case let .serachUser(name, page):
      parameters = [
        "q": name,
        "page": page,
      ]
    }

    return parameters
  }

  public var task: Task {
    guard let parameters = parameters else {
      return .requestPlain
    }

    switch self {
    case .serachUser:
      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
  }

  public var headers: [String : String]? {
    return ["Accept": "application/vnd.github.v3+json"]
  }
}
