//  NetworkRequest.swift
import Foundation

public struct NetworkRequest {
    public let url: URL
    public let method: HTTPMethod
    public var headers: HTTPHeaders
    public var queryParameters: QueryParameters?
    public var body: Data?
    public var timeout: TimeInterval?
    
    public init(url: URL, method: HTTPMethod, headers: HTTPHeaders = [:], queryParameters: QueryParameters? = nil, body: Data? = nil, timeout: TimeInterval? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.timeout = timeout
    }
}
