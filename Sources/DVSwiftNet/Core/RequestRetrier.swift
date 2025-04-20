//  RequestRetrier.swift
import Foundation

public protocol RequestRetrier {
    func shouldRetry(_ request: URLRequest, dueTo error: Error) async -> Bool
}
