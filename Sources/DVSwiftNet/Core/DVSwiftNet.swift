//  DVSwiftNet.swift
//  Main entry point for the DVSwiftNet framework

import Foundation

public final class DVSwiftNet {
    public static let shared = DVSwiftNet()
    public let session: NetworkSession
    public let imageCache: ImageCache
    public let fileDownloader: FileDownloader
    public let logger: Logger?

    public init(
        session: NetworkSession = NetworkSession(),
        imageCache: ImageCache = ImageCache(),
        fileDownloader: FileDownloader = FileDownloader(),
        logger: Logger? = nil
    ) {
        self.session = session
        self.imageCache = imageCache
        self.fileDownloader = fileDownloader
        self.logger = logger
    }
}
