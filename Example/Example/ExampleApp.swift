//
//  ExampleApp.swift
//  Example
//
//  Created by Ruyther Costa on 2024-06-19.
//

import SwiftUI
import NetworkMonitor

@main
struct ExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitorSDK.startMonitoring()
        return true
    }
}
