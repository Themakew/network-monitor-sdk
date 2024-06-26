//
//  LoggerSpy.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-25.
//

import Foundation

final class LoggerSpy: LoggerProtocol {
    var startURL: URL?
    var duration: TimeInterval?
    var finalURL: URL?
    var redirected: Bool?
    var status: String?

    func logRequest(startURL: URL?, duration: TimeInterval, finalURL: URL?, redirected: Bool, status: String) {
        self.startURL = startURL
        self.duration = duration
        self.finalURL = finalURL
        self.redirected = redirected
        self.status = status
    }
}
