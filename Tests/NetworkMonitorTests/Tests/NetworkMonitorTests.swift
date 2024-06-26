//
//  NetworkMonitorTests.swift
//  NetworkMonitorTests
//
//  Created by Ruyther Costa on 2024-06-19.
//

import XCTest
@testable import NetworkMonitor

final class NetworkMonitorTests: XCTestCase {
    private var loggerSpy: LoggerSpy!

    override func setUp() {
        super.setUp()
        loggerSpy = LoggerSpy()
        NetworkMonitorSDK.startMonitoring(with: loggerSpy)
    }

    func testSwizzledDataTaskWithURLRequest() {
        let urlRequest = URLRequest(url: URL(string: "URL1")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Verify that the data task is created with the correct URL
            XCTAssertEqual(response?.url, urlRequest.url)
            
            // Verify logging
            XCTAssertEqual(self.loggerSpy.startURL, urlRequest.url)
            XCTAssertFalse(self.loggerSpy.redirected ?? true)
            XCTAssertEqual(self.loggerSpy.status, "FAILURE")
        }
        task.resume()
    }
}
