import Foundation

protocol NetworkServiceProtocol {
    nonisolated func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: String]?,
        body: Encodable?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T
}

extension NetworkServiceProtocol {
    nonisolated func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .GET,
        queryParameters: [String: String]? = nil,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            path: path,
            method: method,
            queryParameters: queryParameters,
            body: body,
            headers: headers,
            responseType: responseType
        )
    }
}
