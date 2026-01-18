import Foundation

protocol DatabaseServiceProtocol {
    func saveFavoriteCity(_ city: FavoriteCity, token: String) async throws
    func getFavoriteCities(userID: String, token: String) async throws
        -> [FavoriteCity]
    func deleteFavoriteCity(id: Int, token: String) async throws
}

final class SupabaseDatabaseService: DatabaseServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService(
            config: .supabase
        )
    ) {
        self.networkService = networkService
    }

    func saveFavoriteCity(_ city: FavoriteCity, token: String) async throws {
        let headers = ["Authorization": "Bearer \(token)"]

        let _: [FavoriteCity] = try await networkService.request(
            path: "/rest/v1/favourite_cities",
            method: .POST,
            queryParameters: nil,
            body: city,
            headers: headers,
            responseType: [FavoriteCity].self
        )
    }

    func getFavoriteCities(userID: String, token: String) async throws
        -> [FavoriteCity]
    {
        let headers = ["Authorization": "Bearer \(token)"]
        let queryParams = [
            "user_id": "eq.\(userID)",
            "select": "*",
        ]

        return try await networkService.request(
            path: "/rest/v1/favourite_cities",
            method: .GET,
            queryParameters: queryParams,
            body: nil,
            headers: headers,
            responseType: [FavoriteCity].self
        )
    }

    func deleteFavoriteCity(id: Int, token: String) async throws {
        let headers = ["Authorization": "Bearer \(token)"]
        let queryParams = ["id": "eq.\(id)"]

        let _: EmptyResponse = try await networkService.request(
            path: "/rest/v1/favourite_cities",
            method: .DELETE,
            queryParameters: queryParams,
            body: nil,
            headers: headers,
            responseType: EmptyResponse.self
        )
    }
}
