//  NetworkResponse.swift
import Foundation

public struct NetworkResponse<T: Decodable> {
    public let value: T?
    public let data: Data?
    public let response: URLResponse?
    public let error: NetworkError?
}
