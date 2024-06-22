//
//  URLSession+Swizzling.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-21.
//

import Foundation

extension URLSession {
    static func swizzleDataTaskMethods() {
        let originalSelectors: [(Selector, Selector)] = [
            (#selector(dataTask(with:) as (URLSession) -> (URL) -> URLSessionDataTask), #selector(swizzled_dataTask(withUrl:))),
            (#selector(dataTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDataTask), #selector(swizzled_dataTask(withRequest:))),
            (#selector(dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask), #selector(swizzled_dataTask(withUrl:completionHandler:))),
            (#selector(dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask), #selector(swizzled_dataTask(withRequest:completionHandler:)))
        ]

        for (originalSelector, swizzledSelector) in originalSelectors {
            guard let originalMethod = class_getInstanceMethod(URLSession.self, originalSelector),
                  let swizzledMethod = class_getInstanceMethod(URLSession.self, swizzledSelector) else {
                continue
            }
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc func swizzled_dataTask(withUrl url: URL) -> URLSessionDataTask {
        let task = swizzled_dataTask(withUrl: url)
        // Monitor task logic here
        return task
    }

    @objc func swizzled_dataTask(withRequest request: URLRequest) -> URLSessionDataTask {
        let task = swizzled_dataTask(withRequest: request)

        let monitoringTask = swizzled_dataTask(withRequest: request) { [weak self] data, response, error in
            self?.monitorDataTask(withRequest: request, data: data, response: response, error: error)
        }
        monitoringTask.resume()
        
        return task
    }

    @objc func swizzled_dataTask(withUrl url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = swizzled_dataTask(withUrl: url, completionHandler: completionHandler)
        // Monitor task logic here
        return task
    }

    @objc func swizzled_dataTask(withRequest request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = swizzled_dataTask(withRequest: request, completionHandler: completionHandler)
        // Monitor task logic here
        return task
    }
}
