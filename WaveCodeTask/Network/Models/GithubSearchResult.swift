//
//  GithubSearchResult.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation

public struct GithubSearchResult {
  public let list: [User]
  public let pageInfo: PageInfo
  public var canLoadMore: Bool {
    return pageInfo.canLoadMore
  }

  // MARK: - Initialization

  public init(list: [User], pageInfo: PageInfo) {
    self.list = list
    self.pageInfo = pageInfo
  }

  public init() {
    self.list = []
    self.pageInfo = PageInfo()
  }
}
