//  ImageCache.swift
import Foundation

public final class ImageCache {
    private let cache = NSCache<NSString, ImageType>()
    
    public init() {}
    
    public func image(forKey key: String) -> ImageType? {
        cache.object(forKey: key as NSString)
    }
    
    public func setImage(_ image: ImageType, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    public func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    public func removeAll() {
        cache.removeAllObjects()
    }
}
