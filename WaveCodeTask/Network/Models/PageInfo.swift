//
//  PageInfo.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation

public struct PageInfo {
  public let nextPage: Int
  public let lastPage: Int

  public var currentPage: Int {
    return nextPage == 1 ? 1 : nextPage - 1
  }

  public var canLoadMore: Bool {
    return lastPage > nextPage
  }

  // MARK: - Initialization

  public init(nextPage: Int, lastPage: Int) {
    self.nextPage = nextPage
    self.lastPage = lastPage
  }

  public init() {
    self.nextPage = 1
    self.lastPage = 1
  }
}
