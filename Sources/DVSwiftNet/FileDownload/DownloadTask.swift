//  DownloadTask.swift
import Foundation

import Foundation

public final class DownloadTask {
    public let url: URL
    public var progress: Double = 0.0
    public var resumeData: Data?
    public var task: URLSessionDownloadTask?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func cancel() {
        task?.cancel(byProducingResumeData: { [weak self] data in
            self?.resumeData = data
        })
    }
    
    public func resume(with session: URLSession) {
        if let resumeData = resumeData {
            task = session.downloadTask(withResumeData: resumeData)
        } else {
            task = session.downloadTask(with: url)
        }
        task?.resume()
    }
}

