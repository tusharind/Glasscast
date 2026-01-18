import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let config: NetworkConfig

    init(session: URLSession = .shared, config: NetworkConfig = .weatherAPI) {
        self.session = session
        self.config = config
    }

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .GET,
        queryParameters: [String: String]? = nil,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: config.baseURL + path)
        else {
            throw NetworkError.invalidURL
        }

        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: config.timeout)
        request.httpMethod = method.rawValue

        // Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Config headers
        config.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Custom Request headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.unknown(error)
            }
        }

        print("[Network] Request: \(method.rawValue) \(url.absoluteString)")
        if let body = body {
            print(
                "[Network] Body: \(String(data: try! JSONEncoder().encode(body), encoding: .utf8) ?? "nil")"
            )
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            print("[Network] URLError: \(error)")
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.networkUnavailable
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(error)
            }
        } catch {
            print("[Network] Error: \(error)")
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        print("[Network] Response: \(httpResponse.statusCode)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("📄 [Network] Data: \(responseString)")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            // Try to parse error message from body
            var errorMessage: String?
            if let json = try? JSONSerialization.jsonObject(with: data)
                as? [String: Any]
            {
                // Supabase (and others) often use "msg", "message", or "error_description"
                errorMessage =
                    json["msg"] as? String
                    ?? json["message"] as? String
                    ?? json["error_description"] as? String
            }

            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403
            {
                if let msg = errorMessage {
                    throw NetworkError.apiError(msg)
                }
                throw NetworkError.unauthorized
            }

            if let msg = errorMessage {
                throw NetworkError.apiError(msg)
            }

            let rawString = String(data: data, encoding: .utf8)
            throw NetworkError.serverError(
                httpResponse.statusCode,
                rawString
            )
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
