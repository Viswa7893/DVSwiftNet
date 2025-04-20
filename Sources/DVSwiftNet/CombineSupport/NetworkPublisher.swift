//  NetworkPublisher.swift
import Foundation
import Combine

import Foundation
import Combine

public struct NetworkPublisher {
    public static func request<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type,
        session: NetworkSession = DVSwiftNet.shared.session,
        logger: Logger? = nil
    ) -> AnyPublisher<NetworkResponse<T>, Never> {
        Future { promise in
            Task {
                let response: NetworkResponse<T> = await session.send(request, responseType: responseType, logger: logger)
                promise(.success(response))
            }
        }
        .eraseToAnyPublisher()
    }
}
