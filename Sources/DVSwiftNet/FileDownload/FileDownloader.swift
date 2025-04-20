//  FileDownloader.swift
import Foundation

import Foundation

public protocol FileDownloadDelegate: AnyObject {
    func downloadDidUpdateProgress(_ progress: Double, for url: URL)
    func downloadDidFinish(_ location: URL, for url: URL)
    func downloadDidFail(_ error: Error, for url: URL)
}

public final class FileDownloader: NSObject, URLSessionDownloadDelegate {
    private lazy var backgroundSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "DVSwiftNet.FileDownloader")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    private var progressHandlers: [URL: (Double) -> Void] = [:]
    private var completionHandlers: [URL: (Result<URL, Error>) -> Void] = [:]
    public weak var delegate: FileDownloadDelegate?

    public func download(
        from url: URL,
        progress: ((Double) -> Void)? = nil,
        completion: ((Result<URL, Error>) -> Void)? = nil
    ) {
        let task = backgroundSession.downloadTask(with: url)
        if let progress = progress { progressHandlers[url] = progress }
        if let completion = completion { completionHandlers[url] = completion }
        task.resume()
    }
    
    // URLSessionDownloadDelegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressHandlers[url]?(progress)
        delegate?.downloadDidUpdateProgress(progress, for: url)
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        completionHandlers[url]?(.success(location))
        delegate?.downloadDidFinish(location, for: url)
        progressHandlers[url] = nil
        completionHandlers[url] = nil
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url, let error = error else { return }
        completionHandlers[url]?(.failure(error))
        delegate?.downloadDidFail(error, for: url)
        progressHandlers[url] = nil
        completionHandlers[url] = nil
    }
}

