//  Plugins.swift
import Foundation

public protocol DVSwiftNetPlugin {
    func willSend(request: URLRequest)
    func didReceive(response: URLResponse?, data: Data?)
}
