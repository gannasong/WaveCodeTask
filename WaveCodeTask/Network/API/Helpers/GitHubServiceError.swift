//
//  GitHubServiceError.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation

public enum GitHubServiceError: Error {
  case connectivity
  case invalidData
  case limitReached
}

extension GitHubServiceError {
  var displayMessage: String {
    switch self {
    case .connectivity:
      return "網路連線失敗，請檢查網路狀況！"
    case .invalidData:
      return "伺服器回傳無效數據，請稍後再試！"
    case .limitReached:
      return "已達到 Github 請求限制，請稍後再試！"
    }
  }
}
