//  NetworkSession.swift
import Foundation

public final class NetworkSession {
    public let urlSession: URLSession
    public var adapters: [RequestAdapter] = []
    public var retriers: [RequestRetrier] = []
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.urlSession = URLSession(configuration: configuration)
    }
    
    public func send<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type,
        logger: Logger? = nil
    ) async -> NetworkResponse<T> {
        var urlRequest: URLRequest
        do {
            // Build URL with query parameters
            var components = URLComponents(url: request.url, resolvingAgainstBaseURL: false)
            if let params = request.queryParameters {
                components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            guard let finalURL = components?.url else {
                return NetworkResponse(value: nil, data: nil, response: nil, error: .invalidURL)
            }
            urlRequest = URLRequest(url: finalURL)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpBody = request.body
            if let timeout = request.timeout {
                urlRequest.timeoutInterval = timeout
            }
            // Apply adapters
            for adapter in adapters {
                urlRequest = try await adapter.adapt(urlRequest)
            }
        } catch {
            return NetworkResponse(value: nil, data: nil, response: nil, error: .requestFailed(error))
        }
        logger?.log(request: urlRequest)
        // Retry logic
        var lastError: Error?
        for attempt in 0...retriers.count {
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                logger?.log(response: response, data: data)
                guard let httpResponse = response as? HTTPURLResponse else {
                    return NetworkResponse(value: nil, data: data, response: response, error: .invalidResponse)
                }
                if (200..<300).contains(httpResponse.statusCode) {
                    let decoded: T? = try? JSONDecoder().decode(T.self, from: data)
                    // Pretty-print JSON on success
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let prettyString = String(data: prettyData, encoding: .utf8) {
                        let endpoint = urlRequest.url?.path ?? ""
                        let header = "\u{1F7E2} [DVSwiftNet] SUCCESSFUL RESPONSE (Pretty JSON) [\(endpoint)]\n" + String(repeating: "=", count: 40)
                        let footer = String(repeating: "=", count: 40)
                        print("\n\(header)\n\(prettyString)\n\(footer)\n")
                        logger?.log("[DVSwiftNet] SUCCESSFUL RESPONSE (Pretty JSON):\n\(prettyString)")
                    } else if let rawString = String(data: data, encoding: .utf8) {
                        let endpoint = urlRequest.url?.path ?? ""
                        let header = "\u{1F7E2} [DVSwiftNet] SUCCESSFUL RESPONSE (Raw Data) [\(endpoint)]\n" + String(repeating: "-", count: 40)
                        let footer = String(repeating: "-", count: 40)
                        print("\n\(header)\n\(rawString)\n\(footer)\n")
                        logger?.log("[DVSwiftNet] SUCCESSFUL RESPONSE (Raw Data):\n\(rawString)")
                    }
                    if decoded == nil {
                        // Try to pretty-print the JSON data
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                           let prettyString = String(data: prettyData, encoding: .utf8) {
                            let endpoint = urlRequest.url?.path ?? ""
                            print("[DVSwiftNet] Response not decodable, pretty JSON for [\(endpoint)]:\n\(prettyString)")
                            logger?.log("[DVSwiftNet] Response not decodable, pretty JSON for [\(endpoint)]:\n\(prettyString)")
                        } else if let rawString = String(data: data, encoding: .utf8) {
                            let endpoint = urlRequest.url?.path ?? ""
                            print("[DVSwiftNet] Response not decodable, raw data for [\(endpoint)]:\n\(rawString)")
                            logger?.log("[DVSwiftNet] Response not decodable, raw data for [\(endpoint)]:\n\(rawString)")
                        }
                        return NetworkResponse(value: nil, data: data, response: response, error: .decodingFailed(NetworkError.decodingFailed(NSError(domain: "Decoding", code: 0))))
                    }
                    return NetworkResponse(value: decoded, data: data, response: response, error: nil)
                } else {
                    return NetworkResponse(value: nil, data: data, response: response, error: .serverError(httpResponse.statusCode, data))
                }
            } catch {
                lastError = error
                var shouldRetry = false
                for retrier in retriers {
                    if await retrier.shouldRetry(urlRequest, dueTo: error) {
                        shouldRetry = true
                        break
                    }
                }
                if !shouldRetry {
                    return NetworkResponse(value: nil, data: nil, response: nil, error: .requestFailed(error))
                }
            }
        }
        return NetworkResponse(value: nil, data: nil, response: nil, error: .requestFailed(lastError ?? NetworkError.unknown))
    }
}
