//
//  NetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-21.
//

import Foundation

@objc public class NetworkMonitorSDK: NSObject {
    @objc public static func startMonitoring() {
        URLSession.swizzleDataTaskMethods()
        debugPrint("Network monitoring started.")
    }
}
