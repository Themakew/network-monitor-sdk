//
//  NetworkMonitorTests.swift
//  NetworkMonitorTests
//
//  Created by Ruyther Costa on 2024-06-19.
//

import XCTest
@testable import NetworkMonitor

final class NetworkMonitorTests: XCTestCase {
    private static var isMonitoringStarted = false

    override class func setUp() {
        super.setUp()
        // Ensure swizzling happens before any test runs
//        if !isMonitoringStarted {
            NetworkMonitorSDK.startMonitoring()
//            isMonitoringStarted = true
//        }
    }

    func testSwizzledDataTaskWithURL() {
        let expectation = self.expectation(description: "Swizzled dataTask(with:) with URL should be called")

        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            expectation.fulfill()
        }

        task.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }

//    func testSwizzledDataTaskWithURLRequest() {
//        let expectation = self.expectation(description: "Swizzled dataTask(with:) with URLRequest should be called")
//
//        let urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            expectation.fulfill()
//        }
//
//        task.resume()
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//
//    func testSwizzledDataTaskWithURLAndCompletionHandler() {
//        let expectation = self.expectation(description: "Swizzled dataTask(with:completionHandler:) with URL should be called")
//
//        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            expectation.fulfill()
//        }
//
//        task.resume()
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//
//    func testSwizzledDataTaskWithURLRequestAndCompletionHandler() {
//        let expectation = self.expectation(description: "Swizzled dataTask(with:completionHandler:) with URLRequest should be called")
//
//        let urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            expectation.fulfill()
//        }
//
//        task.resume()
//        waitForExpectations(timeout: 10, handler: nil)
//    }
}
