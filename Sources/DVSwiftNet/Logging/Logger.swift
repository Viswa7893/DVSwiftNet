//  Logger.swift
import Foundation

public protocol Logger {
    func log(_ message: String)
    func log(request: URLRequest)
    func log(response: URLResponse?, data: Data?)
}
