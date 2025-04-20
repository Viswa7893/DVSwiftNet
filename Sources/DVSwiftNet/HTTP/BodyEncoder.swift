//  BodyEncoder.swift
import Foundation

public protocol BodyEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

public struct JSONBodyEncoder: BodyEncoder {
    public func encode<T>(_ value: T) throws -> Data where T : Encodable {
        try JSONEncoder().encode(value)
    }
}
