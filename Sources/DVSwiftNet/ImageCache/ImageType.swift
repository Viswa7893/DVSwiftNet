//  ImageType.swift
#if canImport(UIKit)
import UIKit
public typealias ImageType = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias ImageType = NSImage
#endif
