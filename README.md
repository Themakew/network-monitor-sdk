# NetworkMonitorSDK

NetworkMonitorSDK is a Swift framework designed to monitor network requests in an iOS application. It uses method swizzling to intercept network requests made through URLSession and logs various details about each request.

## Features

- Monitors all network requests made through URLSession
- Logs the start URL, duration, final URL, redirection status, and status of each request
- Easily extensible and customizable logging mechanism

## Installation

### **Cocoapodsr**

To integrate NetworkMonitorSDK into your project using Cocoapods, add the following dependency to your `Podfile`:

```
  pod 'NetworkMonitor', :git => 'https://github.com/Themakew/network-monitor-sdk.git', :tag => '1.0.0'
```

### **Manual Installation**

- Clone the repository.
- Drag and drop the NetworkMonitorSDK directory into your Xcode project.
- Ensure that the NetworkMonitorSDK files are included in your target.

### **Usage**

#### Start Monitoring

In your AppDelegate or the entry point of your application, start the network monitoring by calling the startMonitoring method of NetworkMonitorSDK.

**Swift**
```swift
import NetworkMonitor

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitorSDK.startMonitoring()
        return true
    }
}
```

**Objective-C**
```objective-c
#import <NetworkMonitor/NetworkMonitor-Swift.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NetworkMonitorSDK startMonitoring];
}
```

## Log Structure

The NetworkMonitorSDK logs detailed information about each network request. The logs are generated using the LoggerProtocol implementation. Below is an example of the log structure and an explanation of each field.

Example Log Output, on a file named `network_log.txt`, inside `Logs` folder.

```
- Request started at: https://example.com/api/data
- Duration: in miliseconds
- Final URL: https://example.com/api/data (IF REDIRECTED OR NOT)
- Status: SUCCESS/FAILURE

FORMAT:

* https://www.newsblur.com/media/img/reader/default_profile_photo.png, 0.0209808349609375, https://www.newsblur.com/media/img/reader/default_profile_photo.png, SUCCESS

```

## License

NetworkMonitorSDK is released under the MIT license. See LICENSE for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request for any bugs, improvements, or new features.

## Contact

For any questions or inquiries, please contact [your email address].

## Disclaimer

This project is provided as-is without any warranty. Use it at your own risk.
