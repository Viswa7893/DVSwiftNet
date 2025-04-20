//  DiskCache.swift
import Foundation
import UIKit
#if canImport(AppKit)
import AppKit
#endif

public final class DiskCache {
    private let cacheDirectory: URL
    private let fileManager = FileManager.default
    
    public init(name: String = "DVSwiftNetDiskCache") {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent(name)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    public func image(forKey key: String) -> ImageType? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        #if canImport(UIKit)
        return UIImage(data: data)
        #elseif canImport(AppKit)
        return NSImage(data: data)
        #endif
    }
    
    public func setImage(_ image: ImageType, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        #if canImport(UIKit)
        guard let data = image.pngData() else { return }
        #elseif canImport(AppKit)
        guard let tiff = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiff), let data = bitmap.representation(using: .png, properties: [:]) else { return }
        #endif
        try? data.write(to: fileURL)
    }
    
    public func removeImage(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    public func removeAll() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else { return }
        for file in files {
            try? fileManager.removeItem(at: file)
        }
    }
}

