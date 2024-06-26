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
            // Data tasks
            (#selector(dataTask(with:) as (URLSession) -> (URL) -> URLSessionDataTask), #selector(swizzled_dataTask(withUrl:))),
            (#selector(dataTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDataTask), #selector(swizzled_dataTask(withRequest:))),
            (#selector(dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask), #selector(swizzled_dataTask(withUrl:completionHandler:))),
            (#selector(dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask), #selector(swizzled_dataTask(withRequest:completionHandler:))),
            
            // Upload tasks
            (#selector(uploadTask(with:from:) as (URLSession) -> (URLRequest, Data) -> URLSessionUploadTask), #selector(swizzled_uploadTask(withRequest:from:))),
            (#selector(uploadTask(with:fromFile:) as (URLSession) -> (URLRequest, URL) -> URLSessionUploadTask), #selector(swizzled_uploadTask(withRequest:fromFile:))),
            (#selector(uploadTask(withStreamedRequest:) as (URLSession) -> (URLRequest) -> URLSessionUploadTask), #selector(swizzled_uploadTask(withStreamedRequest:))),
            
            // Download tasks
            (#selector(downloadTask(with:) as (URLSession) -> (URL) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withUrl:))),
            (#selector(downloadTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withRequest:))),
            (#selector(downloadTask(withResumeData:) as (URLSession) -> (Data) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withResumeData:))),
            (#selector(downloadTask(with:completionHandler:) as (URLSession) -> (URL, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withUrl:completionHandler:))),
            (#selector(downloadTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withRequest:completionHandler:))),
            (#selector(downloadTask(withResumeData:completionHandler:) as (URLSession) -> (Data, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask), #selector(swizzled_downloadTask(withResumeData:completionHandler:)))
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
    
    @objc func swizzled_uploadTask(withRequest request: URLRequest, from bodyData: Data) -> URLSessionUploadTask {
        let originalTask = swizzled_uploadTask(withRequest: request, from: bodyData)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_uploadTask(withRequest request: URLRequest, fromFile fileURL: URL) -> URLSessionUploadTask {
        let originalTask = swizzled_uploadTask(withRequest: request, fromFile: fileURL)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_uploadTask(withStreamedRequest request: URLRequest) -> URLSessionUploadTask {
        let originalTask = swizzled_uploadTask(withStreamedRequest: request)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withUrl url: URL) -> URLSessionDownloadTask {
        let originalTask = swizzled_downloadTask(withUrl: url)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withRequest request: URLRequest) -> URLSessionDownloadTask {
        let originalTask = swizzled_downloadTask(withRequest: request)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTask {
        let originalTask = swizzled_downloadTask(withResumeData: resumeData)
        originalTask.addObserver(self, forKeyPath: #keyPath(URLSessionTask.state), options: .new, context: nil)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withUrl url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let wrappedCompletionHandler: (URL?, URLResponse?, Error?) -> Void = { [weak self] location, response, error in
            let request = URLRequest(url: url)
            self?.monitorDataTask(withRequest: request, data: nil, response: response, error: error)
            completionHandler(location, response, error)
        }
        let originalTask = swizzled_downloadTask(withUrl: url, completionHandler: wrappedCompletionHandler)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withRequest request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let wrappedCompletionHandler: (URL?, URLResponse?, Error?) -> Void = { [weak self] location, response, error in
            self?.monitorDataTask(withRequest: request, data: nil, response: response, error: error)
            completionHandler(location, response, error)
        }
        let originalTask = swizzled_downloadTask(withRequest: request, completionHandler: wrappedCompletionHandler)
        return originalTask
    }
    
    @objc func swizzled_downloadTask(withResumeData resumeData: Data, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let wrappedCompletionHandler: (URL?, URLResponse?, Error?) -> Void = { [weak self] url, response, error in
            let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
            self?.monitorDataTask(withRequest: request, data: nil, response: response, error: error)
            completionHandler(url, response, error)
        }
        let originalTask = swizzled_downloadTask(withResumeData: resumeData, completionHandler: wrappedCompletionHandler)
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
