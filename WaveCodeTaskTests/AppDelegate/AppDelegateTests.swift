//
//  AppDelegateTests.swift
//  WaveCodeTaskTests
//
//  Created by SUNG HAO LIN on 2021/9/11.
//

import XCTest
@testable import WaveCodeTask

class AppDelegateTests: XCTestCase {

  func test_configureWindow_setsWindowAsKeyAndVisible() {
    let window = UIWindow()
    let sut = AppDelegate()

    sut.window = window
    sut.configureWindow()

    XCTAssertTrue(window.isKeyWindow, "Expected window to be the key window")
    XCTAssertFalse(window.isHidden, "Expected window to be visible")
  }

  func test_configureWindow_configuresRootViewController() {
    let sut = AppDelegate()
    sut.window = UIWindow()

    sut.configureWindow()

    let root = sut.window?.rootViewController
    let rootNavigation = root as? UINavigationController
    let topController = rootNavigation?.topViewController

    XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
    XCTAssertTrue(topController is ViewController, "Expected a search controller as top view controller, got \(String(describing: topController)) instead")
  }
}
