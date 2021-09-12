//
//  AppDelegate.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/11.
//

import UIKit
import Nuke

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    configureWindow()

    setNukeImageCache()
    return true
  }
  
  func configureWindow() {
    let controller = makeSearchViewController()
    window?.rootViewController = UINavigationController(rootViewController: controller)
    window?.makeKeyAndVisible()
  }

  // MARK: - Private Methods

  private func setNukeImageCache() {
    ImageCache.shared.costLimit = 1024 * 1024 * 96
  }

  private func makeSearchViewController() -> GithubSearchViewController {
    let viewModel = SearchResultViewModel()
    let controller = GithubSearchViewController(viewModel: viewModel)
    return controller
  }
}
