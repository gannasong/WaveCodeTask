//
//  UIImageView+Extensions.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import UIKit
import Nuke

extension UIImageView {
  func setImage(with url: String) {
    guard let url = URL(string: url) else { return }

    let options = ImageLoadingOptions(placeholder: UIImage(named: "placeholder"),
                                      transition: .fadeIn(duration: 0.33))
    Nuke.loadImage(with: url, options: options, into: self)
  }

  func cancelImageLoad() {
    Nuke.cancelRequest(for: self)
  }
}
