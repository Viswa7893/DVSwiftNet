//  NetworkAsync.swift
import Foundation

import Foundation

public struct NetworkAsync {
    public static func request<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type,
        session: NetworkSession = DVSwiftNet.shared.session,
        logger: Logger? = nil
    ) async -> NetworkResponse<T> {
        await session.send(request, responseType: responseType, logger: logger)
    }
}
