//
//  ViewModelType.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation

public protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
