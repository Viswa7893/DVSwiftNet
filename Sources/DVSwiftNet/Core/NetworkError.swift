//  NetworkError.swift
import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int, Data?)
    case cancelled
    case unknown
}
