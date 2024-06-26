//
//  URLSessionDataTask+Swizzling.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-21.
//

import Foundation

extension URLSession {
    func monitorDataTask(
        withRequest request: URLRequest,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) {
        let startDate = Date()
        let startURL = request.url
        var finalURL: URL? = startURL
        var redirected = false

        if let httpResponse = response as? HTTPURLResponse, (300...399).contains(httpResponse.statusCode) {
            finalURL = httpResponse.url
            redirected = true
        }

        let durationInSeconds = Date().timeIntervalSince(startDate)
        let durationInMilliseconds = durationInSeconds * 1000
        let status = error == nil ? "SUCCESS" : "FAILURE"
        
        NetworkMonitorSDK.logger.logRequest(
            startURL: startURL,
            duration: durationInMilliseconds,
            finalURL: finalURL,
            redirected: redirected,
            status: status
        )
    }
}
