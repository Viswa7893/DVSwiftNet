# DVSwiftNet

A modern, extensible, and lightweight Swift networking framework for iOS, macOS, and cross-platform Swift projects. DVSwiftNet makes it easy to perform network requests, handle responses, download files, and manage image caching with a clean and modular API.

---

## Features

- **Async/Await and Combine Support**: Use modern Swift concurrency or Combine publishers for networking.
- **Simple Request Building**: Easily create and send requests with customizable headers, query parameters, and body.
- **Automatic Decoding**: Decode JSON responses into strongly-typed models.
- **Retry and Adaptation**: Plug in request adapters and retriers for advanced networking flows.
- **File Downloading**: Download files with progress tracking and delegate callbacks.
- **Image Caching**: In-memory and disk image caching for efficient image management.
- **Logging and Plugins**: Customizable logging and plugin hooks for request/response interception.
- **Cross-Platform**: Works on iOS and macOS (UIKit & AppKit support).

---

## Installation

### Swift Package Manager (SPM)

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/yourusername/DVSwiftNet.git", from: "1.0.0")
```

Or in Xcode: **File > Add Packages...** and enter your repository URL.

---

## Usage

### Basic Request with Async/Await

```swift
import DVSwiftNet

let request = NetworkRequest(url: URL(string: "https://api.example.com/data")!, method: .get)
let response: NetworkResponse<MyModel> = await NetworkAsync.request(request, responseType: MyModel.self)

if let value = response.value {
    print("Received: \(value)")
} else if let error = response.error {
    print("Error: \(error)")
}
```

### Using Combine

```swift
import DVSwiftNet
import Combine

let request = NetworkRequest(url: URL(string: "https://api.example.com/data")!, method: .get)
NetworkPublisher.request(request, responseType: MyModel.self)
    .sink { response in
        if let value = response.value {
            print("Received: \(value)")
        }
    }
    .store(in: &cancellables)
```

### File Downloading

```swift
let downloader = FileDownloader()
downloader.download(from: URL(string: "https://example.com/file.zip")!)
```

### Image Caching

```swift
let imageCache = ImageCache()
imageCache.setImage(myImage, forKey: "profile")
let cached = imageCache.image(forKey: "profile")
```

---

## Architecture Overview

- **DVSwiftNet**: Main entry point, provides shared instances of session, image cache, downloader, and logger.
- **NetworkSession**: Handles sending requests, applying adapters/retriers, and decoding responses.
- **NetworkRequest / NetworkResponse**: Models for requests and responses.
- **RequestAdapter / RequestRetrier**: Protocols for custom request mutation and retry logic.
- **FileDownloader / DownloadTask**: File downloading utilities with delegate callbacks.
- **ImageCache / DiskCache**: In-memory and disk image caching.
- **Logger**: Protocol for custom logging.
- **Plugins**: Protocol for request/response hooks.

---

## Extending DVSwiftNet

- **Custom Adapters/Retries**: Implement `RequestAdapter` or `RequestRetrier` and add to `NetworkSession`.
- **Plugins**: Implement `DVSwiftNetPlugin` for request/response interception.
- **Custom Logging**: Implement the `Logger` protocol.

---

## Example Models

```swift
struct MyModel: Codable {
    let id: Int
    let name: String
}
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Contributing

Pull requests and issues are welcome! Please open an issue to discuss your ideas or report bugs.

---

## Credits

Developed by durgaviswanadh. Inspired by modern networking needs for Swift projects.
