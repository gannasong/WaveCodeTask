//
//  APIManager.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation
import Moya

public class APIManager {

  public static var shared = APIManager()

  let provider = MoyaProvider<GitHubAPI>()
}
