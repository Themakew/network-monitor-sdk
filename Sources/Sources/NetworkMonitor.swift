//
//  NetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-21.
//

import Foundation

@objc public protocol LoggerProtocol {
    func logRequest(startURL: URL?, duration: TimeInterval, finalURL: URL?, redirected: Bool, status: String)
}

@objc public class NetworkMonitorSDK: NSObject {
    public static var logger: LoggerProtocol = MonitorLogger()

    @objc public static func startMonitoring() {
        startMonitoring(with: logger)
    }

    @objc public static func startMonitoring(with logger: LoggerProtocol) {
        self.logger = logger
        URLSession.swizzleDataTaskMethods()
        debugPrint("Network monitoring started.")
    }
}
