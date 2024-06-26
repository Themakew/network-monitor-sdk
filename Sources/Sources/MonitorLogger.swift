//
//  MonitorLogger.swift
//  NetworkMonitor
//
//  Created by Ruyther Costa on 2024-06-25.
//

import Foundation

final class MonitorLogger: LoggerProtocol {
    func logRequest(startURL: URL?, duration: TimeInterval, finalURL: URL?, redirected: Bool, status: String) {
        guard let startURL = startURL else {
            return
        }

        let logEntry = " * \(startURL.absoluteString), \(duration), \(finalURL?.absoluteString ?? ""), \(status)\n"
        saveLogEntry(logEntry)
    }

    private func saveLogEntry(_ logEntry: String) {
        let fileManager = FileManager.default
        let frameworkBundle = Bundle(for: NetworkMonitorSDK.self)

        guard let frameworkPath = frameworkBundle.resourcePath else {
            debugPrint("Could not determine the framework path.")
            return
        }

        guard let logsDirectory = getLogDirectory(fileManager, frameworkPath) else {
            return
        }

        let fileURL = URL(fileURLWithPath: logsDirectory).appendingPathComponent("network_log.txt")
        if !fileManager.fileExists(atPath: fileURL.path) {
            fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }

        writeLogsOnFile(fileURL, logEntry)
    }

    private func getLogDirectory(_ fileManager: FileManager, _ frameworkPath: String) -> String? {
        let logsDirectory = frameworkPath.appending("/Logs")
        if !fileManager.fileExists(atPath: logsDirectory) {
            do {
                try fileManager.createDirectory(atPath: logsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("Failed to create Logs directory: \(error)")
                return ""
            }
        }

        return logsDirectory
    }

    private func writeLogsOnFile(_ fileURL: URL, _ logEntry: String) {
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()

            if let data = logEntry.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
            debugPrint(fileURL)
        } catch {
            debugPrint("Failed to write to log file: \(error)")
        }
    }
}
