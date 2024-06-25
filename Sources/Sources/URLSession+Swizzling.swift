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
        let originalTask = swizzled_dataTask(withUrl: url)

        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)

        return originalTask
    }

    @objc func swizzled_dataTask(withRequest request: URLRequest) -> URLSessionDataTask {
        let originalTask = swizzled_dataTask(withRequest: request)

        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)

        return originalTask
    }

    @objc func swizzled_dataTask(withUrl url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let wrappedCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            let request = URLRequest(url: url)
            self?.monitorDataTask(withRequest: request, data: data, response: response, error: error)
            completionHandler(data, response, error)
        }

        let originalTask = swizzled_dataTask(withUrl: url, completionHandler: wrappedCompletionHandler)
        return originalTask
    }

    @objc func swizzled_dataTask(withRequest request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let wrappedCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            self?.monitorDataTask(withRequest: request, data: data, response: response, error: error)
            completionHandler(data, response, error)
        }
        
        let originalTask = swizzled_dataTask(withRequest: request, completionHandler: wrappedCompletionHandler)
        return originalTask
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(URLSessionTask.state) {
            if let task = object as? URLSessionDataTask {
                switch task.state {
                case .completed:
                    task.removeObserver(self, forKeyPath: #keyPath(URLSessionTask.state))

                    guard let request = task.currentRequest else {
                        return
                    }

                    if let error = task.error {
                        self.monitorDataTask(withRequest: request, data: nil, response: task.response, error: error)
                    } else {
                        self.monitorDataTask(withRequest: request, data: nil, response: task.response, error: nil)
                    }
                default:
                    break
                }
            }
        }
    }
}
