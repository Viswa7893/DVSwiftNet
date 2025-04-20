//  RequestAdapter.swift
import Foundation

public protocol RequestAdapter {
    func adapt(_ request: URLRequest) async throws -> URLRequest
}
