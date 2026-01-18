import Foundation

protocol AuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> AuthResponse
    func signIn(email: String, password: String) async throws -> AuthResponse
    func signOut(accessToken: String) async throws
}

final class AuthService: AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol

    // Use the Supabase-configured NetworkService by default, but allow injection
    init(
        networkService: NetworkServiceProtocol = NetworkService(
            config: .supabase
        )
    ) {
        self.networkService = networkService
    }

    func signUp(email: String, password: String) async throws -> AuthResponse {
        let request = AuthRequest(email: email, password: password)
        return try await networkService.request(
            path: "/auth/v1/signup",
            method: .POST,
            queryParameters: nil,
            body: request,
            responseType: AuthResponse.self
        )
    }

    func signIn(email: String, password: String) async throws -> AuthResponse {
        let request = AuthRequest(email: email, password: password)
        // grant_type=password is required for some Supabase setups, but basic email/pass often uses /token?grant_type=password
        // Standard Supabase /auth/v1/token?grant_type=password

        // Actually, Supabase signIn with password is often /auth/v1/token?grant_type=password
        // OR /auth/v1/signup for sign up.

        return try await networkService.request(
            path: "/auth/v1/token",
            method: .POST,
            queryParameters: ["grant_type": "password"],
            body: request,
            responseType: AuthResponse.self
        )
    }

    func signOut(accessToken: String) async throws {
        let headers = ["Authorization": "Bearer \(accessToken)"]

        let _: EmptyResponse = try await networkService.request(
            path: "/auth/v1/logout",
            method: .POST,
            queryParameters: nil,
            body: nil,
            headers: headers,
            responseType: EmptyResponse.self
        )
    }
}

struct EmptyResponse: Decodable {}
