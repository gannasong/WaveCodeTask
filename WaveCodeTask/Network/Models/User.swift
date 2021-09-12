//
//  User.swift
//  WaveCodeTaskTests
//
//  Created by SUNG HAO LIN on 2021/9/11.
//

import Foundation

public struct User: Decodable, Hashable {
  public let login: String
  public let avatar_url: String

  public init(login: String, avatar_url: String) {
    self.login = login
    self.avatar_url = avatar_url
  }
}
