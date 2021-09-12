//
//  UIViewController+FlexibleBanner.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import UIKit
import SwiftMessages

extension UIViewController {
  func showMessageBanner(theme: Theme, title: String, message: String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureTheme(theme)
    view.configureDropShadow()
    view.configureContent(title: title, body: message)
    view.button?.isHidden = true

    var config = SwiftMessages.Config()
    config.presentationStyle = .top
    config.duration = .seconds(seconds: 3.0)
    config.presentationContext = .window(windowLevel: .statusBar)
    SwiftMessages.show(config: config, view: view)
  }
}
