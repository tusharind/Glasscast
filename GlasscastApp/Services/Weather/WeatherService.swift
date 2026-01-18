import Foundation

protocol WeatherServiceProtocol {
    func getCurrentWeather(for city: String) async throws -> WeatherResponse
    // Future: func getForecast(for city: String, days: Int) async throws -> ForecastResponse
}

final class WeatherService: WeatherServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String

    init(
        networkService: NetworkServiceProtocol = NetworkService(
            config: .weatherAPI
        ),
        apiKey: String = NetworkConfig.weatherAPIKey
    ) {
        self.networkService = networkService
        self.apiKey = apiKey
    }

    func getCurrentWeather(for city: String) async throws -> WeatherResponse {
        let queryParams = [
            "key": apiKey,
            "q": city,
            "aqi": "no",
        ]

        return try await networkService.request(
            path: "/current.json",
            method: .GET,
            queryParameters: queryParams,
            responseType: WeatherResponse.self
        )
    }
}
