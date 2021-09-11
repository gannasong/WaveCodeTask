//
//  AppDelegate.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    return true
  }
}
