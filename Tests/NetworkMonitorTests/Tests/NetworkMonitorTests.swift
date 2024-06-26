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
            DispatchQueue.main.async {
                // Verify that the data task is created with the correct URL
                XCTAssertEqual(response?.url, urlRequest.url)

                // Verify logging
                XCTAssertEqual(self.loggerSpy.startURL, urlRequest.url)
                XCTAssertFalse(self.loggerSpy.redirected ?? true)
                XCTAssertEqual(self.loggerSpy.status, "FAILURE")
            }
        }
        task.resume()
    }

    func testSwizzledDataTaskWithURL() {
        let url = URL(string: "URL2")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                // Verify that the data task is created with the correct URL
                XCTAssertEqual(response?.url, url)

                // Verify logging
                XCTAssertEqual(self.loggerSpy.startURL, url)
                XCTAssertFalse(self.loggerSpy.redirected ?? true)
                XCTAssertEqual(self.loggerSpy.status, "FAILURE")
            }
        }
        task.resume()
    }

    func testSwizzledDownloadTaskWithURL() {
        let url = URL(string: "URL3")!
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                // Verify that the data task is created with the correct URL
                XCTAssertEqual(response?.url, url)

                // Verify logging
                XCTAssertEqual(self.loggerSpy.startURL, url)
                XCTAssertFalse(self.loggerSpy.redirected ?? true)
                XCTAssertEqual(self.loggerSpy.status, "FAILURE")
            }
        }
        task.resume()
    }

    func testSwizzledDownloadTaskWithRequest() {
        let urlRequest = URLRequest(url: URL(string: "URL4")!)
        let task = URLSession.shared.downloadTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                // Verify that the data task is created with the correct URL
                XCTAssertEqual(response?.url, urlRequest.url)

                // Verify logging
                XCTAssertEqual(self.loggerSpy.startURL, urlRequest.url)
                XCTAssertFalse(self.loggerSpy.redirected ?? true)
                XCTAssertEqual(self.loggerSpy.status, "FAILURE")
            }
        }
        task.resume()
    }

    func testSwizzledDownloadTaskWithResumeData() {
        let task = URLSession.shared.downloadTask(withResumeData: Data()) { data, response, error in
            DispatchQueue.main.async {
                // Verify logging
                XCTAssertFalse(self.loggerSpy.redirected ?? true)
                XCTAssertEqual(self.loggerSpy.status, "FAILURE")
            }
        }
        task.resume()
    }
}
