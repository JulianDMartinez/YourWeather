//
//  AppCoordinatorTests.swift
//  YourWeatherTests
//
//  Created by Julian Martinez on 9/26/24.
//

import XCTest
@testable import YourWeather

@MainActor
final class AppCoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator!
    var container: DIContainer!

    override func setUp() {
        super.setUp()
        container = DIContainer.makeMock()
        coordinator = AppCoordinator(container: container)
    }

    override func tearDown() {
        coordinator = nil
        container = nil
        super.tearDown()
    }

    func testInitialPathsIsEmpty() {
        XCTAssertTrue(coordinator.paths.isEmpty)
    }

    func testPushToWeather() {
        coordinator.push(to: .weather)
        XCTAssertEqual(coordinator.paths.count, 1)
        XCTAssertEqual(coordinator.paths.last, .weather)
    }

    func testPopToRoot() {
        coordinator.push(to: .weather)
        coordinator.popToRoot()
        XCTAssertTrue(coordinator.paths.isEmpty)
    }

    func testPopLast() {
        coordinator.push(to: .weather)
        coordinator.popLast()
        XCTAssertTrue(coordinator.paths.isEmpty)
    }
}
